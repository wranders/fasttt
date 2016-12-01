if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	local tritiumsightstbl = {
		id				=	4096, --ID for Tritium Sights
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"tritiumsights",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/tritiumsights",
		name 		=	"Tritium Sights",
		desc 		=	"Provides illuminating sights in the dark."
	}
	
	table.insert( AttachTable, tritiumsightstbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_tritiumsights_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_tritiumsights_aquire")
	local available 	=	GetConVar("ttt_fas2_att_tritiumsights_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_tritiumsights_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], tritiumsightstbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], tritiumsightstbl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], tritiumsightstbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], tritiumsightstbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/tritiumsights.vmt" )
			
			util.AddNetworkString( "PlayerBoughtTritiumSights" )
			net.Receive( "PlayerBoughtTritiumSights", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "tritiumsights") then
						plyr:FAS2_PickUpAttachment("tritiumsights")
					end
				end
			end )
		end
		
		if CLIENT then
			hook.Add( "TTTBoughtItem", "TritiumSightsBoughtItem", function ( is_item, id )
				if is_item and id == 4096 then
					net.Start( "PlayerBoughtTritiumSights" )
					net.SendToServer()
				end
			end)
			
			hook.Add( "TTTBeginRound", "TritiumSightsDefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtTritiumSights" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtTritiumSights" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtTritiumSights" )
						net.SendToServer()
					end
				end
			end)
		end
	end
end