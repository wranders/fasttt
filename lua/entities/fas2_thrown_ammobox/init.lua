if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("shared.lua")
	include("shared.lua")
	
	local phys, ef
	
	function ENT:Initialize()
		self:SetModel("models/weapons/w_ammobox_thrown.mdl") 
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self.AmmoGiveDelay = 0
		self.AmmoCharge = 18
		phys = self:GetPhysicsObject()
	
		if phys and phys:IsValid() then
			phys:Wake()
		end
		
		self:GetPhysicsObject():SetBuoyancyRatio(0)
	end
	
	function ENT:Use(activator, caller)
		return false
	end
	
	function ENT:OnRemove()
		return false
	end 
	
	local wep, am, amc, cl, ammo, mag, CT, pos, ef
	
	function ENT:OnTakeDamage()
		if self.Detonated then
			return
		end
		
		self.Detonated = true
		pos = self:GetPos()
		
		util.BlastDamage(self, self, pos, 384, 100)
		util.BlastDamage(self, self, pos, 768, 75)
		
		ef = EffectData()
		ef:SetOrigin(pos)
		ef:SetMagnitude(1)
		
		util.Effect("Explosion", ef)
	
		if self:WaterLevel() > 0 then
			ParticleEffect("water_explosion", pos, Angle(0, 0, 0), nil)
		else
			ParticleEffect("grenade_final", pos, Angle(0, 0, 0), nil)
		end
		
		self:EmitSound("weapons/explosive_m67/m67_explode_" .. math.random(1, 6) .. ".wav", 120, math.random(95, 105))
		self:Remove()
	end

	function ENT:Think()
		if SERVER then
			CT = CurTime()
			
			if CT > self.AmmoGiveDelay then
				for k, v in pairs(ents.FindInSphere(self:GetPos(), 96)) do
					if v:IsPlayer() and v:Alive() then
						if self.AmmoCharge > 0 then
							wep = v:GetActiveWeapon()
							am = wep:GetPrimaryAmmoType()
							
							if am != -1 then
								amc = v:GetAmmoCount(am)
								
								if wep.Primary and wep.Primary.ClipSize then
									mag = wep:Clip1()
									
									if wep.Primary.ClipSize * 6 * (wep.MaxAmmoMod and wep.MaxAmmoMod or 1) + math.Clamp(wep.Primary.ClipSize - mag, 0, wep.Primary.ClipSize) > amc then
										self.AmmoCharge = self.AmmoCharge - 1
										v:EmitSound("items/ammo_pickup.wav", 60, 100)
										
										ammo = math.Clamp(amc + (wep.Primary.ClipSize > 50 and wep.Primary.ClipSize / 2 or wep.Primary.ClipSize) * (wep.GiveAmmoMod and wep.GiveAmmoMod or 1), 0, wep.Primary.ClipSize * 6 * (wep.MaxAmmoMod and wep.MaxAmmoMod or 1) + math.Clamp(wep.Primary.ClipSize - mag, 0, wep.Primary.ClipSize))
										v:SetAmmo(ammo, am)
									end
								end
							end
							
							cl = wep:GetClass()
							
							for k2, v2 in ipairs(v:GetWeapons()) do
								am = v2:GetPrimaryAmmoType()
								amc = v:GetAmmoCount(am)
								
								if amc == 0 and v2:Clip1() == 0 and cl != v2:GetClass() then
									if v2.Primary and v2.Primary.ClipSize then
										v:SetAmmo(v2.Primary.ClipSize * 0.5, am)
									else
										v:SetAmmo(15, am)
									end
								end	
							end
						
							if wep.Secondary and wep.Secondary.Ammo != "none" and v:GetAmmoCount(wep.Secondary.Ammo) < 6 then
								v:GiveAmmo(1, wep.Secondary.Ammo)
								self.AmmoCharge = self.AmmoCharge - 1
							end
						else
							SafeRemoveEntity(self)
						end
					end
				end
				
				self.AmmoGiveDelay = CT + 0.4
			end
		end
	end
end