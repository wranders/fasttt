if GAMEMODE_NAME == "terrortown" then	
	AddCSLuaFile()
	
	SWEP.Base = "weapon_tttbase"
	SWEP.Category = "TTT FA:S 2.0 Weapons"
	SWEP.TableName = "ammocrate"
	SWEP.EquipMenuData = {
		type = "Support",
		desc = "Ammunition Cache"
	};
	
	local enabled = GetConVar("ttt_fas2_sup_ammocrate_enabled")
	local aquire = GetConVar("ttt_fas2_sup_ammocrate_aquire")
	local available = GetConVar("ttt_fas2_sup_ammocrate_available")
	local defaultfor = GetConVar("ttt_fas2_sup_ammocrate_defaultfor")
	
	if enabled:GetInt() == 1 then 
		if aquire:GetInt() == 0 then
			SWEP.Kind = WEAPON_EQUIP1
			SWEP.Slot = 6
			if available:GetInt() == 0 then
				SWEP.CanBuy = { ROLE_TRAITOR }
			elseif available:GetInt() == 1 then
				SWEP.CanBuy = { ROLE_DETECTIVE }
			elseif available:GetInt() == 2 then
				SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }
			end
		elseif aquire:GetInt() == 1 then
			SWEP.Kind = WEAPON_PISTOL
			SWEP.Slot = 1
			SWEP.CanBuy = { }
		end
		SWEP.Icon = "vgui/ttt_fas2_icons/ammocrate"
		if SERVER then
			resource.AddFile( "materials/vgui/ttt_fas2_icons/ammocrate.vmt" )
		end
		if defaultfor:GetInt() == 0 then
			SWEP.InLoadoutFor = nil
		elseif defaultfor:GetInt() == 1 then
			SWEP.InLoadoutFor = { ROLE_TRAITOR }
		elseif defaultfor:GetInt() == 2 then
			SWEP.InLoadoutFor = { ROLE_DETECTIVE }
		end
		SWEP.LimitedStock = true
		SWEP.AllowDrop = true
		SWEP.IsSilent = true
		SWEP.NoSights = true
		SWEP.AutoSpawnable = true
		
		SWEP.PrintName = "Ammocrate"
		SWEP.HoldType = "normal"
		
		SWEP.ViewModel = "models/weapons/v_ammobox.mdl"
		SWEP.WorldModel = "models/weapons/w_ammobox_thrown.mdl"
		--SWEP.ViewModelFOV    = 53
		SWEP.ViewModelFlip = false
		
		SWEP.DrawCrosshair = false
		SWEP.Primary.ClipSize	=	-1
		SWEP.Primary.DefaultClip	=	-1
		SWEP.Primary.Automatic	=	true
		SWEP.Primary.Ammo	=	"none"
		SWEP.Primary.Delay	=	1.0
		
		SWEP.Secondary.ClipSize	=	-1
		SWEP.Secondary.DefaultClip	=	-1
		SWEP.Secondary.Automatic	=	true
		SWEP.Secondary.Ammo	=	"none"
		SWEP.Secondary.Delay	=	1.0
		
		function SWEP:OnDrop()
			self:Remove()
		end
		
		local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )
		
		function SWEP:AmmocrateDrop()
			if SERVER then
				local ply	=	self.Owner
				if not IsValid(ply) then return end
				
				if self.Planted then return end
				
				local vsrc = ply:GetShootPos()
				local vang = ply:GetAimVector()
				local vvel = ply:GetVelocity()
				
				local vthrow = vvel + vang * 200
				
				local ammo = ents.Create("ttt_fas2_ent_ammocrate")
				if IsValid(ammo) then
					ammo:SetPos(vsrc + vang * 10)
					ammo:Spawn()
					ammo:Activate()
					constraint.Keepupright( ammo, Angle(0,0,0), 0, 100000 )
					
					ammo:SetPlacer(ply)
					
					ammo:PhysWake()
					local phys = ammo:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetVelocity(vthrow)
					end
					self:Remove()
					
					self.Planted = true
				end
			end
			
			self:EmitSound(throwsound)
			
		end
		
		function SWEP:PrimaryAttack()
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self:AmmocrateDrop()
		end
		
		function SWEP:SecondaryAttack()
			self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
			self:AmmocrateDrop()
		end
		
		function SWEP:Reload()
			return false
		end
		
		function SWEP:OnRemove()
			if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
				RunConsoleCommand("lastinv")
			end
		end
		
		if CLIENT then
			function SWEP:Initialize()
				return self.BaseClass.Initialize(self)
			end
		end
		
		function SWEP:Deploy()
			if SERVER and IsValid(self.Owner) then
				self.Owner:DrawViewModel(false)
			end
			return true
		end
		
		function SWEP:DrawWorldModel()
		end
		
		function SWEP:DrawWorldModelTranslucent()
		end
	end
end