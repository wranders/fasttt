if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	ENT.Type = "anim"
	ENT.Base = "base_ammo_ttt"
	ENT.AmmoType = "Bandages"
	ENT.AmmoAmount = 10
	ENT.AmmoMax = 10
	ENT.Model = Model("models/Items/BoxMRounds.mdl") 
	ENT.AutoSpawnable = true
end