if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("shared.lua")
	include("shared.lua")
	
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
		self.ArmTime = CurTime() + 0.2
		
		spd = physenv.GetPerformanceSettings()
		spd.MaxVelocity = 2992
		
		physenv.SetPerformanceSettings(spd)
	end
	
	function ENT:Use(activator, caller)
		return false
	end
	
	function ENT:OnRemove()
		return false
	end 
	
	local vel, len, pos, owner
	
	function ENT:PhysicsCollide(data, physobj)
		if self.dt.Misfire then
			vel = physobj:GetVelocity()
			len = vel:Length()
			
			if len > 500 then
				physobj:SetVelocity(vel * 0.6)
			end
		
			return
		end
		
		if CurTime() > self.ArmTime then
			pos, owner = self:GetPos(), self:GetOwner()
	
			util.BlastDamage(self, owner, pos, self.BlastRadius, self.BlastDamage)
			
			local ef = EffectData()
			ef:SetOrigin(pos)
			ef:SetMagnitude(1)
			util.Effect("Explosion", ef)
			
			if self:WaterLevel() > 0 then
				ParticleEffect("water_explosion", pos, Angle(0, 0, 0), nil)
			else
				ParticleEffect("explosion_m79", pos, Angle(-90, 0, math.random(0, 360)), nil)
			end
				
			self:EmitSound("weapons/explosive_m79/m79_explode1.wav", 120, math.random(95, 105))
				
			self:Remove()
		else
			self:EmitSound("physics/metal/metal_grenade_impact_hard" .. math.random(1, 3) .. ".wav", 80, 100)
			self.dt.Misfire = true
			SafeRemoveEntityDelayed(self, 10)
			
			vel = physobj:GetVelocity()
			len = vel:Length()
			
			if len > 500 then
				physobj:SetVelocity(vel * 0.6)
			end
		end
	end
end