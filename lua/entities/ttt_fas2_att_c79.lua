if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	local c79tbl = {
		id				=	16, --ID for ELCAN C79
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"c79",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/c79",
		name 		=	"ELCAN C79",
		desc 		=	"Provides 3.4x magnification.\nIs disorienting when engaging targets at close range.\nNarrow scope greatly reduces awareness."
	}
	
	table.insert( AttachTable, c79tbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_c79_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_c79_aquire")
	local available 	=	GetConVar("ttt_fas2_att_c79_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_c79_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], c79tbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], c79tbl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], c79tbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], c79tbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/c79.vmt" )
			
			util.AddNetworkString( "PlayerBoughtC79" )
			net.Receive( "PlayerBoughtC79", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "c79") then
						plyr:FAS2_PickUpAttachment("c79")
					end
				end
			end )
		end
		
		if CLIENT then
			hook.Add( "TTTBoughtItem", "C79BoughtItem", function ( is_item, id )
				if is_item and id == 16 then
					net.Start( "PlayerBoughtC79" )
					net.SendToServer()
				end
			end)
			
			hook.Add( "TTTBeginRound", "C79DefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtC79" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtC79" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtC79" )
						net.SendToServer()
					end
				end
			end)
		end
	end
end
