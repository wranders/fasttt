if GAMEMODE_NAME == "terrortown" then
	ENT.Type = "anim"
	ENT.Base = "base_entity"
	ENT.PrintName = "Launcher smoke grenade"
	ENT.Author = "L337N008"
	ENT.Information = "A 40MM grenade launched from an underslung grenade launcher M203"
	ENT.Spawnable = false
	ENT.AdminSpawnable = false 
	
	function ENT:SetupDataTables()
		self:DTVar("Bool", 0, "Misfire")
	end
end