purelogs.list = purelogs.list or {}

--[[
	Variables
]]

local os = os
local net = net
local gui = gui
local vgui = vgui
local hook = hook
local table = table
local string = string
local surface = surface

local ScrW = ScrW
local ScrH = ScrH
local pairs = pairs
local CurTime = CurTime
local IsValid = IsValid

local GAMEMODE = GAMEMODE

local purelogs = purelogs

local nextOpen = 0

--[[
	Fonts
]]

surface.CreateFont("purelogs-log", {
	font = "Roboto",
	size = (ScrH()/1080)*16,
	weight = 500,
	antialias = true,
})

--[[
	Functions
]]

function purelogs.init()
	local sw, sh = ScrW(), ScrH()
	local rw, rh = sw/1920, sh/1080

	local frame = vgui.Create("DFrame")
	frame:SetSize(rw*1024, rh*600)
	frame:Center()
	frame:SetTitle("Purelogs - Console")
	frame:SetVisible(false)
	frame.Close = purelogs.hide
	frame.OnKeyCodePressed = function(_, key)
		if key ~= purelogs.cfg.key then return end
		if nextOpen > CurTime() then return end

		purelogs.hide()
		nextOpen = CurTime() + 0.5
	end

	local richtext = frame:Add("RichText")
	richtext:Dock(FILL)
	richtext:DockMargin(rw*10, rh*10, rw*10, rh*10)
	richtext.PerformLayout = function()
		richtext:SetFontInternal("purelogs-log")
	end
	richtext.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 60)
		surface.DrawRect(0, 0, w, h)
	end

	local textentry = frame:Add("DTextEntry")
	textentry:Dock(TOP)
	textentry:DockMargin(rw*10, rh*10, rw*10, 0)
	textentry:SetTall(rh*30)
	textentry:SetFont("purelogs-log")
	textentry:SetPlaceholderText("Search")
	textentry.OnChange = function()
        local query = textentry:GetValue():lower()
        purelogs.filter(query)
    end

	purelogs.frame = frame
	purelogs.richtext = richtext
	purelogs.textentry = textentry
end

function purelogs.show()
	purelogs.frame:SetVisible(true)
	purelogs.frame:MoveToFront()
	purelogs.frame:MakePopup()
end

function purelogs.hide()
	purelogs.frame:SetVisible(false)
	purelogs.frame:MoveToBack()
end

function purelogs.filter(query)
    if not IsValid(purelogs.richtext) then return end

    purelogs.richtext:SetText("")

    for _, log in ipairs(purelogs.list) do
        local text = log.text
        local color = log.color
        local time = log.time

        if query == "" or string.find(text:lower(), query, 1, true) then
            purelogs.richtext:InsertColorChange(255, 255, 0, 255)
            purelogs.richtext:AppendText("[" .. os.date("%H:%M:%S", time) .. "] - ")
            purelogs.richtext:InsertColorChange(color.r, color.g, color.b, 255)
            purelogs.richtext:AppendText(text .. "\n")
        end
    end
end

function purelogs.add(text, color)
	if not IsValid(purelogs.frame) then purelogs.init() end
	if not IsValid(purelogs.richtext) then return end

	color = color or purelogs.cfg.colors["white"]

	local log = {text = text, color = color, time = os.time()}
    table.insert(purelogs.list, log)

	local query = IsValid(purelogs.textentry) and purelogs.textentry:GetValue():lower() or ""
    if query ~= "" then purelogs.filter(query) return end

	purelogs.richtext:InsertColorChange(255, 255, 0, 255)
	purelogs.richtext:AppendText("[" .. os.date("%H:%M:%S", os.time()) .. "] - ")
	purelogs.richtext:InsertColorChange(color.r, color.g, color.b, 255)
	purelogs.richtext:AppendText(text .. "\n")
end

--[[
	Hooks
]]

hook.Add("InitPostEntity", "purelogs.menu", purelogs.init)

hook.Add("PlayerButtonDown", "purelogs.menu", function(ply, key)
	if key ~= purelogs.cfg.key then return end
	if nextOpen > CurTime() then return end

	if ply ~= LocalPlayer() or not ply:IsSuperAdmin() then return end
	if vgui.CursorVisible() or gui.IsConsoleVisible() then return end

	if not IsValid(purelogs.frame) then purelogs.init() end
	if purelogs.frame:IsVisible() then purelogs.hide() else purelogs.show() end

	nextOpen = CurTime() + 0.5
end)

--[[
	Networks
]]

net.Receive("purelogs.send", function()
	local text = net.ReadString()
	local color = net.ReadColor()

	purelogs.add(text, color)
	hook.Call("PurelogsAdd", GAMEMODE, text, color)
end)