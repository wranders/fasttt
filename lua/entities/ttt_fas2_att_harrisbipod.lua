if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	local harrisbipodtbl = {
		id				=	256, --ID for Harris Bipod
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"harrisbipod",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/harrisbipod",
		name 		=	"Harris Bipod",
		desc 		=	"When deployed:\nDecreases recoil by 70%\nDecreases maximum spread from continuous fire by\n     70%\nDecreases mouse sensitivity by 30%"
	}	
	
	table.insert( AttachTable, harrisbipodtbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_harrisbipod_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_harrisbipod_aquire")
	local available 	=	GetConVar("ttt_fas2_att_harrisbipod_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_harrisbipod_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], harrisbipodtbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], harrisbipodtbl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], harrisbipodtbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], harrisbipodtbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/harrisbipod.vmt" )
			
			util.AddNetworkString( "PlayerBoughtHarrisBipod" )
			net.Receive( "PlayerBoughtHarrisBipod", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "harrisbipod") then
						plyr:FAS2_PickUpAttachment("harrisbipod")
					end
				end
			end )
		end
		
		if CLIENT then
			hook.Add( "TTTBoughtItem", "HarrisBipodBoughtItem", function ( is_item, id )
				if is_item and id == 256 then
					net.Start( "PlayerBoughtHarrisBipod" )
					net.SendToServer()
				end
			end)
			
			hook.Add( "TTTBeginRound", "HarrisBipodDefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtHarrisBipod" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtHarrisBipod" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtHarrisBipod" )
						net.SendToServer()
					end
				end
			end)
		end
	end
end