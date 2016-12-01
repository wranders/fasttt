if GAMEMODE_NAME == "terrortown" then
	for _, wep in pairs( weapons.GetList() ) do
		if wep.ClassName == "fas2_m4a1" then
			AddCSLuaFile("weapons/fas2_m4a1/shared.lua")
			
			include("weapons/fas2_m4a1/shared.lua")
			
			SWEP.Base = "ttt_fas2_base"
			SWEP.Category = "TTT FA:S 2.0 Weapons"
			SWEP.TableName = "m4a1"
			SWEP.EquipMenuData = {
				type = "Weapon",
				desc = "Colt Defense M4A1"
			};
			
			local enabled = GetConVar("ttt_fas2_wep_m4a1_enabled")
			local aquire = GetConVar("ttt_fas2_wep_m4a1_aquire")
			local available = GetConVar("ttt_fas2_wep_m4a1_available")
			local defaultfor = GetConVar("ttt_fas2_wep_m4a1_defaultfor")
			
			if enabled:GetInt() == 1 then 
				if aquire:GetInt() == 0 then
					SWEP.Kind = WEAPON_EQUIP1
					SWEP.Slot = 6
					if available:GetInt() == 0 then
						SWEP.CanBuy = { ROLE_TRAITOR }
					elseif available:GetInt() == 1 then
						SWEP.CanBuy = { ROLE_DETECTIVE }
					elseif available:GetInt() == 2 then
						SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }
					end
				elseif aquire:GetInt() == 1 then
					SWEP.Kind = WEAPON_HEAVY
					SWEP.Slot = 2
					SWEP.CanBuy = { }
				end
				SWEP.AmmoEnt = "ttt_fas2_ammo_556x45"
				SWEP.Icon = "VGUI/entities/fas2_m4a1"
				if SERVER then
					resource.AddFile( "materials/VGUI/entities/fas2_m4a1.vmt" )
				end 
				if defaultfor:GetInt() == 0 then
					SWEP.InLoadoutFor = nil
				elseif defaultfor:GetInt() == 1 then
					SWEP.InLoadoutFor = { ROLE_TRAITOR }
				elseif defaultfor:GetInt() == 2 then
					SWEP.InLoadoutFor = { ROLE_DETECTIVE }
				end
				SWEP.LimitedStock = false
				SWEP.AllowDrop = true
				SWEP.IsSilent = false
				SWEP.NoSights = false
				SWEP.AutoSpawnable = true
				
				SWEP.Primary.DefaultClip    = SWEP.Primary.ClipSize
			end
		end
	end
end