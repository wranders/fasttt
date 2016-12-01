if GAMEMODE_NAME == "terrortown" then
	for _, wep in pairs( weapons.GetList() ) do
		if wep.ClassName == "fas2_ammobox" then
			AddCSLuaFile("weapons/fas2_ammobox/shared.lua")
			
			include("weapons/fas2_ammobox/shared.lua")
			
			SWEP.Base = "ttt_fas2_base"
			SWEP.Category = "TTT FA:S 2.0 Weapons"
			SWEP.TableName = "ammobox"
			SWEP.EquipMenuData = {
				type = "Weapon",
				desc = "Ammo Can IED"
			};
			
			local enabled = GetConVar("ttt_fas2_wep_ammobox_enabled")
			local aquire = GetConVar("ttt_fas2_wep_ammobox_aquire")
			local available = GetConVar("ttt_fas2_wep_ammobox_available")
			local defaultfor = GetConVar("ttt_fas2_wep_ammobox_defaultfor")
			
			if enabled:GetInt() == 1 then
				if aquire:GetInt() == 0 then
					SWEP.Kind = WEAPON_EQUIP2
					SWEP.Slot = 7
					if available:GetInt() == 0 then
						SWEP.CanBuy = { ROLE_TRAITOR }
					elseif available:GetInt() == 1 then
						SWEP.CanBuy = { ROLE_DETECTIVE }
					elseif available:GetInt() == 2 then
						SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }
					end
				elseif aquire:GetInt() == 1 then
					SWEP.Kind = WEAPON_PISTOL
					SWEP.Slot = 1
					SWEP.CanBuy = { }
				end
				if defaultfor:GetInt() == 0 then
					SWEP.InLoadoutFor = nil
				elseif defaultfor:GetInt() == 1 then
					SWEP.InLoadoutFor = { ROLE_TRAITOR }
				elseif defaultfor:GetInt() == 2 then
					SWEP.InLoadoutFor = { ROLE_DETECTIVE }
				end
				SWEP.LimitedStock = false
				SWEP.Icon = "VGUI/ttt_fas2_icons/ammobox"
				if SERVER then
					resource.AddFile( "materials/VGUI/ttt_fas2_icons/ammobox.vmt" )
				end
				SWEP.AllowDrop = false
				SWEP.IsSilent = false
				SWEP.NoSights = true
				SWEP.AutoSpawnable = false
				SWEP.Primary.DefaultClip    = 1
			end
		end
	end
end