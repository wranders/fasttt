if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()	
	
	local uziwoodenstocktbl = {
		id				=	8192, --ID for UZI Wooden Stock
		category	=	"TTT FA:S 2.0 Attachment",
		tablename	=	"uziwoodenstock",
		type			=	"Attachment",
		material	=	"vgui/fas2atts/uzi_woodenstock",
		name 		=	"Uzi Wooden Stock",
		desc 		=	"Decreases recoil by 20%"
	}
	
	table.insert( AttachTable, uziwoodenstocktbl )
	
	local enabled 	= 	GetConVar("ttt_fas2_att_uziwoodenstock_enabled")
	local aquire 		= 	GetConVar("ttt_fas2_att_uziwoodenstock_aquire")
	local available 	=	GetConVar("ttt_fas2_att_uziwoodenstock_available")
	local defaultfor	=	GetConVar("ttt_fas2_att_uziwoodenstock_defaultfor")
	
	if enabled:GetInt() == 1 then
		if aquire:GetInt() == 0 then
			if available:GetInt() == 0 and defaultfor:GetInt() != 1 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], uziwoodenstocktbl )
			elseif available:GetInt() == 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], uziwoodenstocktbl )
			elseif available:GetInt() == 2 and defaultfor:GetInt() != 1 and defaultfor:GetInt() != 2 then
				table.insert( EquipmentItems[ ROLE_TRAITOR ], uziwoodenstocktbl )
				table.insert( EquipmentItems[ ROLE_DETECTIVE ], uziwoodenstocktbl )
			end
		end
		
		if SERVER then
			resource.AddFile( "materials/vgui/fas2atts/uzi_woodenstock.vmt" )
			
			util.AddNetworkString( "PlayerBoughtUziWS" )
			net.Receive( "PlayerBoughtUziWS", function( len, plyr)
				if plyr:IsPlayer() then
					if not table.HasValue(plyr.FAS2Attachments, "uziwoodenstock") then
						plyr:FAS2_PickUpAttachment("uziwoodenstock")
					end
				end
			end )
		end
	
		if CLIENT then
			hook.Add( "TTTBoughtItem", "UziWSBoughtItem", function ( is_item, id )
				if is_item and id == 8192 then
					net.Start( "PlayerBoughtUziWS" )
					net.SendToServer()
				end
			end)
			
			hook.Add( "TTTBeginRound", "UziWSDefaultItem", function()
				if FASisMounted then
					if aquire:GetInt() == 1 then
						net.Start( "PlayerBoughtUziWS" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 1 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_TRAITOR then
						net.Start( "PlayerBoughtUziWS" )
						net.SendToServer()
					end
					
					if defaultfor:GetInt() == 2 and aquire:GetInt() == 0 and LocalPlayer():GetRole() == ROLE_DETECTIVE then
						net.Start( "PlayerBoughtUziWS" )
						net.SendToServer()
					end
				end
			end)
		end
	end
end