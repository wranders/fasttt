if GAMEMODE_NAME == "terrortown" then
--	for k, addon in pairs( engine.GetAddons() ) do
--		if ( addon.wsid == "180507408" ) and addon.mounted then
			AddCSLuaFile("weapons/fas2_base/shared.lua")
			include("weapons/fas2_base/shared.lua")
--		end
--	end
	
	SWEP.Base = "weapon_tttbase"
	
	if CLIENT then
		function SWEP.PlayerBindPress(ply, b, p)
			if p then
				wep = ply:GetActiveWeapon()
	
				if wep.IsFAS2Weapon then
					if b == "noclip" and not wep.NoAttachmentMenu then
						if wep.dt.Status != FAS_STAT_ADS then
							if not wep.dt.Bipod then
								if wep.Attachments then
									wep.ShowStats = false
								else
									wep.ShowStats = true
								end
								
								RunConsoleCommand("fas2_togglegunpimper")
								return true
							end
						else
							wep.Peeking = true
							return true
						end
					end
					
					if b == "+use" then
						if wep.dt.Status == FAS_STAT_CUSTOMIZE then
							if wep.Attachments then
								wep.ShowStats = !wep.ShowStats
							end
							
							return true
						end
					end
					
					if wep.Attachments then
						if wep.dt.Status == FAS_STAT_CUSTOMIZE then
							if b:find("slot") then
								if wep.ShowStats then
									return true
								end
							
								num = tonumber(string.Right(b, 1))
								
								if wep.Attachments[num] then
									att = wep:CycleAttachments(num)
									
									if not att then
										wep:Detach(num)
									else
										wep:Attach(num, att)
									end
								end
								
								return true
							end
						end
					end
				end
			else
				if b == "noclip" then
					wep.Peeking = false
				end
			end
		end
	
		hook.Add("PlayerBindPress", "SWEP.PlayerBindPress (FAS2)", SWEP.PlayerBindPress)
		
		function SWEP:CycleAttachments(group)
			t = self.Attachments[group]
			found = false
			total = 0
			for k, v in ipairs(t.atts) do
				if not t.last then
					t.last = {}
				end
				if table.HasValue(FAS2AttOnMe, v) then
					total = total + 1
					if not t.last[v] then
						found = v
						break
					end
				end
			end
			if total == 0 then
				chat.AddText(Color(255, 255, 255), "You have ", Color(255, 125, 125), "no attachments", Color(255, 255, 255), " in the ", Color(255, 187, 104), t.header, Color(255, 255, 255), " category.")
				surface.PlaySound("weapons/noattachments.wav")
			end
			return found
		end
	
		LANG.AddToLanguage("english", "ammo_9x19mm", "9mm Parabellum Ammo")
		LANG.AddToLanguage("english", "ammo_9x18mm", "9mm Makarov Ammo")
		LANG.AddToLanguage("english", "ammo_10x25mm", "10mm Auto Ammo")
		LANG.AddToLanguage("english", "ammo_7.62x51mm", "7.62 NATO Ammo")
		LANG.AddToLanguage("english", "ammo_5.56x45mm", "5.56 NATO Ammo")
		LANG.AddToLanguage("english", "ammo_5.45x39mm", "5.45x39mm Ammo")
		LANG.AddToLanguage("english", "ammo_7.62x39mm", "7.62x39mm Ammo")
		LANG.AddToLanguage("english", "ammo_.357 sig", ".357 SIG Ammo")
		LANG.AddToLanguage("english", "ammo_.380 acp", ".380 ACP Ammo")
		LANG.AddToLanguage("english", "ammo_.45 acp", ".45 ACP Ammo")
		LANG.AddToLanguage("english", "ammo_.44 magnum", ".44 Magnum Ammo")
		LANG.AddToLanguage("english", "ammo_.454 casull", ".454 Casull Ammo")
		LANG.AddToLanguage("english", "ammo_.50 ae", ".50 AE Ammo")
		LANG.AddToLanguage("english", "ammo_.50 bmg", ".50 BMG Ammo")
		LANG.AddToLanguage("english", "ammo_12 gauge", "12 Gauge Ammo")
		LANG.AddToLanguage("english", "ammo_23x75mmr", "23x75mmR Ammo")
		
		LANG.AddToLanguage("english", "ammo_40mm he", "40mm HE Ammo")
		LANG.AddToLanguage("english", "ammo_40mm smoke", "40mm Smoke Ammo")
		LANG.AddToLanguage("english", "ammo_m67 grenades", "M67 Grenades")
		LANG.AddToLanguage("english", "ammo_ammoboxes", "Ammoboxes")
		
		LANG.AddToLanguage("english", "ammo_bandages", "Bandages")
		LANG.AddToLanguage("english", "ammo_quikclots", "Quikclots")
		LANG.AddToLanguage("english", "ammo_hemostats", "Hemostats")
	end

	function SWEP:PreDrop()
		return
	end
end