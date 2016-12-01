if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	local eotechtbl = {
		id				=	64, --ID for EoTech 553
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"eotech",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/eotech553",
		name 		=	"EoTech 553",
		desc 		=	"Provides a bright red sphere-like reticle to ease \n     aiming."
	}
	
	table.insert( AttachTable, eotechtbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_eotech_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_eotech_aquire")
	local available 	=	GetConVar("ttt_fas2_att_eotech_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_eotech_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], eotechtbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], eotechtbl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], eotechtbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], eotechtbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/eotech553.vmt" )
			
			util.AddNetworkString( "PlayerBoughtEoTech" )
			net.Receive( "PlayerBoughtEoTech", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "eotech") then
						plyr:FAS2_PickUpAttachment("eotech")
					end
				end
			end )
		end
		
		if CLIENT then
			hook.Add( "TTTBoughtItem", "EoTechBoughtItem", function ( is_item, id )
				if is_item and id == 64 then
					net.Start( "PlayerBoughtEoTech" )
					net.SendToServer()
				end
			end)
			
			hook.Add( "TTTBeginRound", "EoTechDefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtEoTech" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtEoTech" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtEoTech" )
						net.SendToServer()
					end
				end
			end)
		end
	end
end