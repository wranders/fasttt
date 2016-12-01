if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile("weapons/fas2_base_shotgun/shared.lua")

	include("weapons/fas2_base_shotgun/shared.lua")

	SWEP.Base = "ttt_fas2_base"
end