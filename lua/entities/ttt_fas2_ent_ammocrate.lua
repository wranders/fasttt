if GAMEMODE_NAME == "terrortown" then
	AddCSLuaFile()
	
	if CLIENT then
		ENT.Icon = "vgui/ttt_fas2_icons/ammocrate"
		ENT.PrintName = "Ammocrate"
		
		ENT.TargetIDHint = {
			name = "Ammocrate",
			hint = "Press " .. Key("+use", "USE") .. " to receive ammunition. Charge: %d.",
			fmt = function(ent, str)
				return Format(str, LocalPlayer():GetEyeTrace().Entity:GetStoredAmmo() )
				end
		};
	end
	
	ENT.Type = "anim"
	ENT.Model = Model("models/items/fas_ammo_crate.mdl")
	ENT.Category = "TTT FA:S 2.0 Ammo"
	ENT.AutomaticFrameAdvance = true 
	ENT.CanHavePrints = true
	ENT.MaxAmmo = 50
	ENT.MaxStored = GetConVarNumber("ttt_fas2_sup_ammocrate_store") or 500
	ENT.NextAmmo = 0
	ENT.AmmoRate = 1
	ENT.AmmoFreq = 0.2
	
	AccessorFuncDT(ENT, "StoredAmmo", "StoredAmmo", FORCE_NUMBER)
	AccessorFunc(ENT, "Placer", "Placer")
	
	function ENT:SetupDataTables()
		self:NetworkVar("Int", 0, "StoredAmmo");
	end
	
	local dmg, wep, am, amc, cl, ammo, ED, pos, mag, anim
		
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
	
		local b = 32
		self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b, b, b))
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self.CanHurt = true
		if SERVER then
			self:SetMaxHealth(200)
			local phys = self:GetPhysicsObject()		
			if IsValid(phys) then
				phys:SetMass(1000)
			end
			self:SetUseType(CONTINUOUS_USE)
		end
		self:SetHealth(200)
		self:SetColor(Color(180, 180, 250, 255))
		self:SetStoredAmmo(self.MaxStored)
		self:SetPlacer(nil)
		self.NextAmmo = 0
		self.fingerprints = {}
		self.AmmoGiveDelay = CurTime()
		self.HP = 100
		self.AnimTimer = -1
	end
	
	function ENT:TakeFromStorage(amount)
		amount = math.min(amount, self:GetStoredAmmo())
		self:SetStoredAmmo(math.max(0, self:GetStoredAmmo() - amount))
		return amount
	end
	
	local ammosound = Sound("items/ammo_pickup.wav")
	local failsound = Sound("items/medshotno1.wav")
	
	local last_sound_time = 2
	
	function ENT:GiveAmmunition(ply, max_ammo)
		if SERVER then
			if CurTime() > self.AmmoGiveDelay then
				if self:GetStoredAmmo() > 0 then
					max_ammo = max_ammo or self.MaxAmmo
					wep = ply:GetActiveWeapon()
					am = wep:GetPrimaryAmmoType()
					
					if am != -1 then
						amc = ply:GetAmmoCount(am)
						
						if (wep.Primary != nil ) and (wep.Primary.Clipsize != 0 ) then
							mag = wep:Clip1()

							if math.Round(wep.Primary.ClipSize * 12 * (wep.MaxAmmoMod and wep.MaxAmmoMod or 1)) + math.Clamp(wep.Primary.ClipSize - mag, 0, wep.Primary.ClipSize) > amc then
								ammo = math.Clamp(amc + (wep.Primary.ClipSize > 50 and wep.Primary.ClipSize / 2 or wep.Primary.ClipSize) * (wep.GiveAmmoMod and wep.GiveAmmoMod or 1), 0, math.Round(wep.Primary.ClipSize * 12 * (wep.MaxAmmoMod and wep.MaxAmmoMod or 1)) + math.Clamp(wep.Primary.ClipSize - mag, 0, wep.Primary.ClipSize))
								
								self:TakeFromStorage(wep.Primary.ClipSize)
								ply:EmitSound("items/ammo_pickup.wav", 60, 100)
								
								ply:SetAmmo(ammo, am)
							end
						end
					end
					
					cl = wep:GetClass()
					
					for k, v in ipairs(ply:GetWeapons()) do
						am = v:GetPrimaryAmmoType()
						amc = ply:GetAmmoCount(am)
						
						if amc == 0 and v:Clip1() == 0 and cl != v:GetClass() then
							if v.Primary and v.Primary.ClipSize then
								ply:SetAmmo(v.Primary.ClipSize * 0.5, am)
							else
								ply:SetAmmo(15, am)
							end
						end
					end
					
					if wep.Secondary and wep.Secondary.Ammo != "none" and ply:GetAmmoCount(wep.Secondary.Ammo) < 12 then
						ply:GiveAmmo(1, wep.Secondary.Ammo)
						self:TakeFromStorage(1)
					end
				else
					SafeRemoveEntity(self)
				end
			end
		end
		self.AmmoGiveDelay = CurTime() + 0.4
	end
	
	function ENT:Use(ply)
		local idleseq = self:LookupSequence("idle")
		local openseq = self:LookupSequence("Open")
		local closeseq = self:LookupSequence("Shut")
		if IsValid(ply) and ply:IsPlayer() then
			local t = CurTime()
			
			if self:GetSequence() == idleseq then
				self:SetSequence(openseq)
				self:ResetSequence(openseq)
				self:SetPlaybackRate(1)
				self.AnimTimer = CurTime() + (self:SequenceDuration() + 8)
			end
			
			self:GiveAmmunition(ply, self.AmmoRate)
		end
	end
	
	function ENT:Think()
		if self:GetSequence() == self:LookupSequence("Open") and (self.AnimTimer <= CurTime() and self.AnimTimer != -1) then
			self:SetSequence(self:LookupSequence("Shut"))
			self:ResetSequence(self:LookupSequence("Shut"))
			self:SetPlaybackRate(0.5)
			self:SetSequence(self:LookupSequence("idle"))
		end
		self:NextThink(CurTime())
		return true
	end
	
	function ENT:OnTakeDamage(dmginfo)
		if self.Exploded then
			return false
		end
		
		self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.02)
		
		dmg = dmginfo:GetDamage()
		self.HP = self.HP - dmg
		
		if self.HP <= 0 then
			local spos = self:GetPos()
			local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
			self.Exploded = true
			
			pos = self:GetPos()
			util.BlastDamage(dmginfo:GetInflictor(), dmginfo:GetAttacker(), pos + Vector(0, 0, 32), 512, 100)
			
			ED = EffectData()
			ED:SetOrigin(pos)
			ED:SetScale(1)
			
			util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)
			
			util.Effect("Explosion", ED)
			SafeRemoveEntity(self)
		end
	end
end	