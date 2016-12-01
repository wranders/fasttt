if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	for _, wep in pairs(weapons.GetList()) do
		if wep.Category == "TTT FA:S 2.0 Weapons" and wep.AmmoEnt == "ttt_fas2_ammo_556x45" then
			ENT.Type = "anim"
			ENT.Base = "base_ammo_ttt"
			ENT.AmmoType = "5.56x45MM"
			ENT.AmmoAmount = 60
			ENT.AmmoMax = 240
			ENT.Model = Model("models/Items/BoxMRounds.mdl") 
			ENT.AutoSpawnable = true
			return
		end
	end
end
