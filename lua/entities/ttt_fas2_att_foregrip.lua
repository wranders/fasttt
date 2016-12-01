if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	local foregriptbl = {
		id				=	128, --ID for Foregrip
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"foregrip",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/foregrip",
		name 		=	"Foregrip",
		desc 		=	"Decreases recoil by 20%"
	}
	
	table.insert( AttachTable, foregriptbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_foregrip_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_foregrip_aquire")
	local available 	=	GetConVar("ttt_fas2_att_foregrip_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_foregrip_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], foregriptbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], foregriptbl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], foregriptbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], foregriptbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/foregrip.vmt" )
			
			util.AddNetworkString( "PlayerBoughtForegrip" )
			net.Receive( "PlayerBoughtForegrip", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "foregrip") then
						plyr:FAS2_PickUpAttachment("foregrip")
					end
				end
			end )
		end
		
		if CLIENT then
			hook.Add( "TTTBoughtItem", "ForegripBoughtItem", function ( is_item, id )
				if is_item and id == 128 then
					net.Start( "PlayerBoughtForegrip" )
					net.SendToServer()
				end
			end)
			
			hook.Add( "TTTBeginRound", "ForegripDefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtForegrip" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtForegrip" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtForegrip" )
						net.SendToServer()
					end
				end
			end)
		end
	end
end