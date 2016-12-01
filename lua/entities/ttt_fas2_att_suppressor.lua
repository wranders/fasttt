if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	local suppressortbl = {
		id				=	2048, --ID for Suppressor
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"suppressor",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/suppressor",
		name 		=	"Suppressor",
		desc 		=	"Decreases firing noise.\nDecreases recoil by 15%\nDecreases damage by 10%"
	}
	
	table.insert( AttachTable, suppressortbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_suppressor_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_suppressor_aquire")
	local available 	=	GetConVar("ttt_fas2_att_suppressor_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_suppressor_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], suppressortbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], suppressortbl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], suppressortbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], suppressortbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/suppressor.vmt" )
			
			util.AddNetworkString( "PlayerBoughtSupp" )
			net.Receive( "PlayerBoughtSupp", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "suppressor" ) then
						plyr:FAS2_PickUpAttachment("suppressor")
					end
				end
			end )
		end
		
		if CLIENT then
			hook.Add( "TTTBoughtItem", "SuppressorBoughtItem", function ( is_item, id )
				if is_item and id == 2048 then
					net.Start( "PlayerBoughtSupp" )
					net.SendToServer()
				end
			end)
			
			hook.Add( "TTTBeginRound", "SuppressorDefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtSupp" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtSupp" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtSupp" )
						net.SendToServer()
					end
				end
			end)
		end
	end
end