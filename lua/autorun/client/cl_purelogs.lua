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
	font = "Roboto Condensed",
	size = (ScrH()/1080)*16,
	weight = 500,
	antialias = true,
})

--[[
	Functions
]]

function purelogs.open(logs)
	local sw, sh = ScrW(), ScrH()
	local rw, rh = sw/1920, sh/1080

	local frame = vgui.Create("DFrame")
	frame:SetSize(rw*1024, rh*600)
	frame:Center()
	frame:SetTitle("Purelogs - Console")
	frame:MakePopup()

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
		purelogs.filter(richtext, logs, query)
	end

    local loading = richtext:Add("DPanel")
    loading:Dock(FILL)
	loading.progress = 0
    loading.Paint = function(_, w, h)
		surface.SetDrawColor(95, 98, 100)
		surface.DrawRect(0, 0, w, h)

        draw.SimpleText("Chargement des logs...", "purelogs-log", w/2, h/2-30, color_white, 1, 1)

		loading.progress = Lerp(FrameTime()*4, loading.progress, 1)

		surface.SetDrawColor(0, 0, 0, 120)
		surface.DrawRect(w/2-150, h/2, 300, 24)

		surface.SetDrawColor(255, 200, 40)
		surface.DrawRect(w/2-150, h/2, 300*loading.progress, 24)
    end

	for _, log in ipairs(logs) do
		richtext:InsertColorChange(255, 255, 0, 255)
		richtext:AppendText("[" .. os.date("%H:%M:%S", log.time) .. "] - ")
		richtext:InsertColorChange(log.color.r, log.color.g, log.color.b, 255)
		richtext:AppendText(log.text .. "\n")
	end

	timer.Simple(1, function()
		if IsValid(richtext) then richtext:GotoTextEnd() end
		if IsValid(loading) then loading:Remove() end
	end)
end

function purelogs.filter(richtext, logs, query)
    richtext:SetText("")

    for _, log in ipairs(logs) do
        if query == "" or string.find(log.text:lower(), query, 1, true) then
            richtext:InsertColorChange(255, 255, 0, 255)
            richtext:AppendText("[" .. os.date("%H:%M:%S", log.time) .. "] - ")
            richtext:InsertColorChange(log.color.r, log.color.g, log.color.b, 255)
            richtext:AppendText(log.text .. "\n")
			richtext:GotoTextEnd()
        end
    end
end

--[[
	Networks
]]

net.Receive("purelogs.menu", function()
	local logs = net.ReadTable()
	if not istable(logs) then return end

	purelogs.open(logs)
end)