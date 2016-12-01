if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("shared.lua")
	include("shared.lua")
	
	local spd, ent
	
	function ENT:Initialize()
		self:SetModel("models/Items/AR2_Grenade.mdl") 
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		local phys = self:GetPhysicsObject()
	
		if phys and phys:IsValid() then
			phys:Wake()
		end
		
		self:GetPhysicsObject():SetBuoyancyRatio(0)
		
		spd = physenv.GetPerformanceSettings()
		spd.MaxVelocity = 2996
		
		physenv.SetPerformanceSettings(spd) -- set grenade's max. speed to it's real life muzzle velocity
	end
	
	function ENT:Use(activator, caller)
		return false
	end
	
	function ENT:OnRemove()
		return false
	end 
	
	function ENT:PhysicsCollide(data, physobj)
		ent = data.HitEntity
		
		//if IsValid(ent) and ent:Health() > 0 then
		//	ent:TakeDamage(30, self.Owner, self.Owner:GetActiveWeapon())
		//end
	
		self:EmitSound("weapons/smokegrenade/sg_explode.wav", 100, 100)
		ParticleEffect("cstm_smoke", self:GetPos(), Angle(0, 0, 0), nil)
		self:Remove()
	end
end