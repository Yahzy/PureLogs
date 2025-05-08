--[[
	Variables
]]

local hook = hook
local team = team
local string = string

local tostring = tostring
local IsValid = IsValid
local Color = Color

local purelogs = purelogs

--[[
	Hooks
]]

hook.Add("PlayerConnect", "purelogs.sandbox", function(name, ip)
	purelogs.log(string.format("%s connected from %s", name, ip), Color(0, 150, 255))
end)

hook.Add("PlayerInitialSpawn", "purelogs.sandbox", function(ply)
	purelogs.log(string.format("%s (%s) joined the server", ply:Name(), ply:SteamID()), Color(100, 200, 255))
end)

hook.Add("PlayerDisconnected", "purelogs.sandbox", function(ply)
	purelogs.log(string.format("%s (%s) disconnected", ply:Name(), ply:SteamID()), Color(150, 150, 150))
end)


hook.Add("PlayerSpawnProp", "purelogs.sandbox", function(ply, model)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) spawned prop: %s", ply:Name(), ply:SteamID(), tostring(model)), Color(0, 255, 0))
end)

hook.Add("PlayerSpawnedEffect", "purelogs.sandbox", function(ply, model)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) spawned effect: %s", ply:Name(), ply:SteamID(), tostring(model)), Color(0, 200, 255))
end)

hook.Add("PlayerSpawnedNPC", "purelogs.sandbox", function(ply, ent)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) spawned NPC: %s", ply:Name(), ply:SteamID(), tostring(ent:GetClass())), Color(255, 200, 0))
end)

hook.Add("PlayerSpawnedVehicle", "purelogs.sandbox", function(ply, ent)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) spawned vehicle: %s", ply:Name(), ply:SteamID(), tostring(ent:GetClass())), Color(200, 100, 255))
end)

hook.Add("PlayerSpawnedSENT", "purelogs.sandbox", function(ply, ent)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) spawned SENT: %s", ply:Name(), ply:SteamID(), tostring(ent:GetClass())), Color(100, 255, 100))
end)

hook.Add("PlayerSpawnedSWEP", "purelogs.sandbox", function(ply, ent)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) spawned weapon: %s", ply:Name(), ply:SteamID(), tostring(ent:GetClass())), Color(200, 255, 100))
end)

hook.Add("PlayerGiveSWEP", "purelogs.sandbox", function(ply, class, swep)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) was given SWEP: %s", ply:Name(), ply:SteamID(), class), Color(0, 255, 200))
end)

hook.Add("CanTool", "purelogs.sandbox", function(ply, tr, tool)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) used tool: %s on %s", ply:Name(), ply:SteamID(), tool, tostring(IsValid(tr.Entity) and tr.Entity:GetClass() or "world")), Color(255, 200, 200))
end)


hook.Add("PlayerDeath", "purelogs.sandbox", function(ply, inf, att)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) was killed by %s (%s)", ply:Name(), ply:SteamID(), IsValid(att) and att:Name() or "World", IsValid(att) and att:SteamID() or "NULL"), Color(255, 0, 0))
end)

hook.Add("PlayerChangedTeam", "purelogs.sandbox", function(ply, old, new)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) changed team: %s -> %s", ply:Name(), ply:SteamID(), team.GetName(old), team.GetName(new)), Color(255, 100, 0))
end)

hook.Add("PlayerSpray", "purelogs.sandbox", function(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) used spray", ply:Name(), ply:SteamID()), Color(255, 0, 255))
end)

hook.Add("PlayerPickupWeapon", "purelogs.sandbox", function(ply, weapon)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	purelogs.log(string.format("%s (%s) picked up weapon: %s", ply:Name(), ply:SteamID(), weapon:GetClass()), Color(255, 150, 50))
end)

hook.Add("PlayerSay", "purelogs.sandbox", function(ply, text)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if string.sub(text, 1, 1) ~= "!" then return end
	purelogs.log(string.format("%s (%s) used command: %s", ply:Name(), ply:SteamID(), text), Color(255, 100, 255))
end)