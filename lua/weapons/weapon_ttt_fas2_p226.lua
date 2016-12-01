if GAMEMODE_NAME == "terrortown" then
	for _, wep in pairs( weapons.GetList() ) do
		if wep.ClassName == "fas2_p226" then
			AddCSLuaFile("weapons/fas2_p226/shared.lua")
			
			include("weapons/fas2_p226/shared.lua")
			
			SWEP.Base = "ttt_fas2_base"
			SWEP.Category = "TTT FA:S 2.0 Weapons"
			SWEP.TableName = "p226"
			SWEP.EquipMenuData = {
				type = "Weapon",
				desc = "SIG Sauer P226"
			};
			
			local enabled = GetConVar("ttt_fas2_wep_p226_enabled")
			local aquire = GetConVar("ttt_fas2_wep_p226_aquire")
			local available = GetConVar("ttt_fas2_wep_p226_available")
			local defaultfor = GetConVar("ttt_fas2_wep_p226_defaultfor")
			
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
					SWEP.Kind = WEAPON_PISTOL
					SWEP.Slot = 1
					SWEP.CanBuy = { }
				end
				SWEP.AmmoEnt = "ttt_fas2_ammo_357sig"
				SWEP.Icon = "VGUI/entities/fas2_p226"
				if SERVER then
					resource.AddFile( "materials/VGUI/entities/fas2_p226.vmt" )
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