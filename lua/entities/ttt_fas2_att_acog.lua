if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	local acogtbl = {
		id				=	8, --ID for ACOG
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"acog",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/acog",
		name 		=	"ACOG",
		desc 		=	"Provides 4x magnification.\nIs disorienting when engaging targets at close range.\nNarrow scope greatly reduces awareness."
	}
	
	table.insert( AttachTable, acogtbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_acog_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_acog_aquire")
	local available 	=	GetConVar("ttt_fas2_att_acog_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_acog_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], acogtbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], acogtbl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], acogtbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], acogtbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/acog.vmt" )
			
			util.AddNetworkString( "PlayerBoughtACOG" )
			net.Receive( "PlayerBoughtACOG", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "acog") then
						plyr:FAS2_PickUpAttachment("acog")
					end
				end
			end )
		end
		
		if CLIENT then
			hook.Add( "TTTBoughtItem", "ACOGBoughtItem", function ( is_item, id )
				print(is_item, id)
				if is_item and id == 8 then
					net.Start( "PlayerBoughtACOG" )
					net.SendToServer()
				end
			end)
			
			hook.Add("TTTBeginRound", "ACOGDefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtACOG" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtACOG" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtACOG" )
						net.SendToServer()
					end
				end
			end)	
		end
	end
end