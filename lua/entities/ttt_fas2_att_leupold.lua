if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	local leupoldtbl = {
		id				=	512, --ID for Leupold MK4
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"leupold",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/mk4",
		name 		=	"Leupold MK4",
		desc 		=	"Provides 8x magnification.\nIs very disorienting when engaging targets at close\n     range.\nNarrow scope greatly reduces awareness."
	}
	
	table.insert( AttachTable, leupoldtbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_leupold_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_leupold_aquire")
	local available 	=	GetConVar("ttt_fas2_att_leupold_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_leupold_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], leupoldtbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], leupoldtbl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], leupoldtbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], leupoldtbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/mk4.vmt" )
			
			util.AddNetworkString( "PlayerBoughtLeupold" )
			net.Receive( "PlayerBoughtLeupold", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "leupold") then
						plyr:FAS2_PickUpAttachment("leupold")
					end
				end
			end )
		end
		
		if CLIENT then
			hook.Add( "TTTBoughtItem", "LeupoldBoughtItem", function ( is_item, id )
				if is_item and id == 512 then
					net.Start( "PlayerBoughtLeupold" )
					net.SendToServer()
				end
			end)
			
			hook.Add( "TTTBeginRound", "LeupoldDefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtLeupold" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtLeupold" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtLeupold" )
						net.SendToServer()
					end
				end
			end)
		end
	end
end