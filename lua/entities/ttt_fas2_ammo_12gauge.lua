if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	for _, wep in pairs(weapons.GetList()) do
		if wep.Category == "TTT FA:S 2.0 Weapons" and wep.AmmoEnt == "ttt_fas2_ammo_12gauge" then
			ENT.Type = "anim"
			ENT.Base = "base_ammo_ttt"
			ENT.AmmoType = "12 Gauge"
			ENT.AmmoAmount = 12
			ENT.AmmoMax = 35
			ENT.Model = Model("models/Items/BoxMRounds.mdl") 
			ENT.AutoSpawnable = true
			return
		end
	end
end
