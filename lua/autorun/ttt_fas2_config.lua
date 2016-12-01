
if !ConVarExists("ttt_fas2_ttt_wep_enabled") then
	CreateConVar("ttt_fas2_ttt_wep_enabled", "1", { FCVAR_ARCHIVE } )
end

TTTFAS2WepSettings = {
	["ak12"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["ak47"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["ak74"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["an94"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["deagle"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["dv2"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 0, ["defaultfor"] = 0 },
	["famas"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["g3"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["g36c"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["galil"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["glock20"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["ks23"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["m3s90"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["m4a1"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["m14"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["m21"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["m24"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["m67"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["m79"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["m82"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["m1911"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["mac11"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["machete"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["mp5a5"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["mp5k"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["mp5sd6"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["ots33"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 0, ["defaultfor"] = 0 },
	["p226"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["pp19"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["ragingbull"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["rem870"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["rk95"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["rpk"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["sg550"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["sg552"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["sks"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["sr25"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["toz34"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["uzi"] = { ["enabled"] = 1, ["aquire"] = 1, ["available"] = 2, ["defaultfor"] = 0 },
	["ammobox"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 1, ["defaultfor"] = 0 }
}

function SetWepStatus(t)
	for k, v in pairs(t) do
		if !ConVarExists("ttt_fas2_wep_" .. k .."_enabled") then
			CreateConVar("ttt_fas2_wep_" .. k .."_enabled", v["enabled"], { FCVAR_ARCHIVE } )
		end
		if !ConVarExists("ttt_fas2_wep_" .. k .."_aquire") then
			CreateConVar("ttt_fas2_wep_" .. k .."_aquire", v["aquire"], { FCVAR_ARCHIVE } )
		end
		if !ConVarExists("ttt_fas2_wep_" .. k .."_available") then
			CreateConVar("ttt_fas2_wep_" .. k .."_available", v["available"], { FCVAR_ARCHIVE } )
		end
		if !ConVarExists("ttt_fas2_wep_" .. k .."_defaultfor") then
			CreateConVar("ttt_fas2_wep_" .. k .."_defaultfor", v["defaultfor"], { FCVAR_ARCHIVE } )
		end
	end
end

SetWepStatus(TTTFAS2WepSettings)                      


TTTFAS2AttSettings = {
	["acog"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["c79"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["compm4"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["eotech"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["foregrip"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["harrisbipod"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["leupold"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["pso1"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["suppressor"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["tritiumsights"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 },
	["uziwoodenstock"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0 }
}
	
function SetAttStatus(t)
	for k, v in pairs(t) do
		if !ConVarExists("ttt_fas2_att_" .. k .."_enabled") then
			CreateConVar("ttt_fas2_att_" .. k .."_enabled", v["enabled"], { FCVAR_ARCHIVE } )
		end
		if !ConVarExists("ttt_fas2_att_" .. k .."_aquire") then
			CreateConVar("ttt_fas2_att_" .. k .."_aquire", v["aquire"], { FCVAR_ARCHIVE } )
		end
		if !ConVarExists("ttt_fas2_att_" .. k .."_available") then
			CreateConVar("ttt_fas2_att_" .. k .."_available", v["available"], { FCVAR_ARCHIVE } )
		end
		if !ConVarExists("ttt_fas2_att_" .. k .."_defaultfor") then
			CreateConVar("ttt_fas2_att_" .. k .."_defaultfor", v["defaultfor"], { FCVAR_ARCHIVE } )
		end
	end
end
	
SetAttStatus(TTTFAS2AttSettings)


function SetDefaultAttachments()
	if SERVER then
		RunConsoleCommand("fas2_att_sks20mag", 1)
		RunConsoleCommand("fas2_att_sks30mag", 1)
		RunConsoleCommand("fas2_att_mp5k30mag", 1)
		RunConsoleCommand("fas2_att_sg55x30mag", 1)
		RunConsoleCommand("fas2_att_m2120mag", 1)
		RunConsoleCommand("fas2_att_slugrounds", 1)
	end
end

SetDefaultAttachments()


TTTFAS2SupSettings = {
	["ammocrate"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0, ["store"] = 500 },
	["ifak"] = { ["enabled"] = 1, ["aquire"] = 0, ["available"] = 2, ["defaultfor"] = 0, ["store"] = -1  }
}
	
function SetSupStatus(t)
	for k, v in pairs(t) do
		if !ConVarExists("ttt_fas2_sup_" .. k .."_enabled") then
			CreateConVar("ttt_fas2_sup_" .. k .."_enabled", v["enabled"], { FCVAR_ARCHIVE } )
		end
		if !ConVarExists("ttt_fas2_sup_" .. k .."_aquire") then
			CreateConVar("ttt_fas2_sup_" .. k .."_aquire", v["aquire"], { FCVAR_ARCHIVE } )
		end
		if !ConVarExists("ttt_fas2_sup_" .. k .."_available") then
			CreateConVar("ttt_fas2_sup_" .. k .."_available", v["available"], { FCVAR_ARCHIVE } )
		end
		if !ConVarExists("ttt_fas2_sup_" .. k .."_defaultfor") then
			CreateConVar("ttt_fas2_sup_" .. k .."_defaultfor", v["defaultfor"], { FCVAR_ARCHIVE } )
		end
		if !ConVarExists("ttt_fas2_sup_" .. k .."_store") then
			CreateConVar("ttt_fas2_sup_" .. k .."_store", v["store"], { FCVAR_ARCHIVE } )
		end
	end
end
	
SetSupStatus(TTTFAS2SupSettings)