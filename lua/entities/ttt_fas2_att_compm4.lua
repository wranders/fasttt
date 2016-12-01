if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	local compm4tbl = {
		id				=	32, --ID for Comp M4
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"compm4",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/compm4",
		name 		=	"CompM4",
		desc 		=	"Provides a bright red reticle to ease aiming.\nSlightly increases aim zoom.\nNarrow scope might slightly reduce awareness."
	}
	
	table.insert( AttachTable, compm4tbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_compm4_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_compm4_aquire")
	local available 	=	GetConVar("ttt_fas2_att_compm4_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_compm4_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], compm4tbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], compm4bl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], compm4tbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], compm4tbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/compm4.vmt" )
			
			util.AddNetworkString( "PlayerBoughtCompM4" )
			net.Receive( "PlayerBoughtCompM4", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "compm4") then
						plyr:FAS2_PickUpAttachment("compm4")
					end
				end
			end )
		end
		
		if CLIENT then
			hook.Add( "TTTBoughtItem", "CompM4BoughtItem", function ( is_item, id )
				if is_item and id == 32 then
					net.Start( "PlayerBoughtCompM4" )
					net.SendToServer()
				end
			end)
		
			hook.Add( "TTTBeginRound", "CompM4DefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtCompM4" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtCompM4" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtCompM4" )
						net.SendToServer()
					end
				end
			end)
		end
	end
end