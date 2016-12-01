if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	for _, wep in pairs(weapons.GetList()) do
		if wep.Category == "TTT FA:S 2.0 Weapons" and wep.AmmoEnt == "ttt_fas2_ammo_50bmg" then
			ENT.Type = "anim"
			ENT.Base = "base_ammo_ttt"
			ENT.AmmoType = ".50 BMG"
			ENT.AmmoAmount  = 20
			ENT.AmmoMax = 50
			ENT.Model = Model("models/Items/BoxMRounds.mdl") 
			ENT.AutoSpawnable = true
			return
		end
	end
end
