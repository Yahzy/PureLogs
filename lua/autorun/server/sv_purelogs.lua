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

	net.Start("purelogs.send")
	net.WriteString(text or "")
	net.WriteColor(color or purelogs.cfg.colors["white"])
	net.Broadcast()

	local path = "purelogs/" .. os.date("%m_%d_%Y") .. ".txt"
	local exists = file.Exists(path, "DATA")
	file[exists and "Append" or "Write"](path, os.date() .. "\t" .. text .. "\n")

	MsgC(purelogs.cfg.colors["log"], "[Logs] ", purelogs.cfg.colors["white"], text, "\n")
	hook.Call("PurelogsAdd", GAMEMODE, text, color)
end

--[[
	Networks
]]

util.AddNetworkString("purelogs.send")