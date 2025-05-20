if not file.IsDir("purelogs", "DATA") then file.CreateDir("purelogs") end

--[[
	Variables
]]

local os = os
local net = net
local hook = hook
local util = util
local file = file
local string = string

local MsgC = MsgC
local type = type
local assert = assert

local GAMEMODE = GAMEMODE

local purelogs = purelogs

--[[
	Functions
]]

function purelogs.log(text, color)
	assert(type(text) == "string", "purelogs.log - 'text' is not a string !")
	assert(type(color) == "table", "purelogs.log - 'color' is not a table !")

	purelogs.list = purelogs.list or {}
	purelogs.list[#purelogs.list + 1] = {text = text, color = color, time = os.time()}

	local path = "purelogs/" .. os.date("%m_%d_%Y") .. ".txt"
	local exists = file.Exists(path, "DATA")
	file[exists and "Append" or "Write"](path, os.date() .. "\t" .. text .. "\n")

	MsgC(purelogs.cfg.colors["log"], "[Logs] ", purelogs.cfg.colors["white"], text, "\n")
	hook.Call("PurelogsAdd", GAMEMODE, text, color)
end

--[[
	Hooks
]]

hook.Add("PlayerButtonDown", "purelogs.menu", function(ply, key)
	if key ~= purelogs.cfg.key then return end
	if not ply:IsSuperAdmin() then return end

	net.Start("purelogs.menu")
	net.WriteTable(purelogs.list)
	net.Send(ply)
end)

--[[
	Networks
]]

util.AddNetworkString("purelogs.menu")