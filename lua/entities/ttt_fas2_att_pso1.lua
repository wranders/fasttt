if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	local pso1tbl = {
		id				=	1024, --ID for PSO-1
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"pso1",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/pso1",
		name 		=	"PSO-1",
		desc 		=	"Provides 4x magnification.\nIs disorienting when engaging targets at close range.\nNarrow scope greatly reduces awareness."
	}
	
	table.insert( AttachTable, pso1tbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_pso1_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_pso1_aquire")
	local available 	=	GetConVar("ttt_fas2_att_pso1_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_pso1_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], pso1tbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], pso1tbl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], pso1tbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], pso1tbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/pso1.vmt" )
			
			util.AddNetworkString( "PlayerBoughtPSO1" )
			net.Receive( "PlayerBoughtPSO1", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "pso1") then
						plyr:FAS2_PickUpAttachment("pso1")
					end
				end
			end )
		end
		
		if CLIENT then
			hook.Add( "TTTBoughtItem", "PSO1BoughtItem", function ( is_item, id )
				if is_item and id == 1024 then
					net.Start( "PlayerBoughtPSO1" )
					net.SendToServer()
				end
			end)
			
			hook.Add( "TTTBeginRound", "PSO1DefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtPSO1" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtPSO1" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtPSO1" )
						net.SendToServer()
					end
				end
			end)
		end
	end
end