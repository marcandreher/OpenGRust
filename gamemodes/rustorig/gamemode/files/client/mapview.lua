local ENEMY_COLOR = Color(100, 100, 100)
local TEAM_COLOR = Color(138, 172, 52)
local OFFSET = Vector(0, 0, 82)
local MAX_DIST = 350000
local MAX_TEAMDIST = 1000000

surface.CreateFont("gRust.Overhead", {
    font = "Roboto Condensed Bold",
    size = 28,
    weight = 2000,
    antialias = true,
    shadow = false,
})

local tr = {}
hook.Add("HUDPaint", "gRust.PlayerOverhead", function()
    local pl = LocalPlayer()
    if not pl:IsValid() then return end
    if not pl:Alive() then DeathPos = pl:GetPos() end
    local players = player.GetAll()
    for i = 1, #players do
        local v = players[i]
        if not v:IsValid() or not v:Alive() or v == pl or v:GetNoDraw() then continue end
        local dist = pl:GetPos():DistToSqr(v:GetPos())
        --[[
        if gRust.TeamsIndex and gRust.TeamsIndex[v:SteamID64()] then
            local pos = v:GetPos() + OFFSET
            pos = pos:ToScreen()
            if pos.visible then
                local alpha = math.Remap(dist, MAX_TEAMDIST - 20000, MAX_TEAMDIST, 255, 0)
                if dist < MAX_DIST then
                    surface.SetAlphaMultiplier(alpha / 255)
                    draw.SimpleTextOutlined(v:Name(), "gRust.Overhead", pos.x, pos.y - 24, TEAM_COLOR, 1, 1, 2, color_black)
                    surface.SetAlphaMultiplier(1)
                end

                if dist < MAX_TEAMDIST then draw.SimpleTextOutlined("•", "gRust.Overhead", pos.x, pos.y, TEAM_COLOR, 1, 1, 2, color_black) end
            end
        else
            tr.start = pl:EyePos()
            tr.endpos = v:EyePos()
            tr.filter = {pl, v}
            if dist < MAX_DIST and not util.TraceLine(tr).Hit then
                local pos = v:GetPos() + OFFSET
                pos = pos:ToScreen()
                local alpha = math.Remap(dist, MAX_DIST - 20000, MAX_DIST, 255, 0)
                surface.SetAlphaMultiplier(alpha / 255)
                draw.SimpleTextOutlined(v:Name(), "gRust.Overhead", pos.x, pos.y - 24, ENEMY_COLOR, 1, 1, 2, color_black)
                draw.SimpleTextOutlined("•", "gRust.Overhead", pos.x, pos.y, ENEMY_COLOR, 1, 1, 2, color_black)
                surface.SetAlphaMultiplier(1)
            end
        end
        ]]--
    end
end)

local MapOpen = false
local MapOpenTime = 0
local MapCloseTime = 0
function PosToMap(realpos)
    local mapBounds = 15750
    local size = ScrH()
    local startX = ScrW() * 0.5 - size * 0.5
    local endX = ScrW() * 0.5 + size * 0.5
    local startY = 0
    local endY = size
    local x = math.Remap(realpos.x, -mapBounds, mapBounds, startX, endX)
    local y = math.Remap(realpos.y, mapBounds, -mapBounds, startY, endY)
    return x, y
end

function MapToPos(x, y)
    local mapBounds = 15750
    local size = ScrH()
    local startX = ScrW() * 0.5 - size * 0.5
    local endX = ScrW() * 0.5 + size * 0.5
    local startY = 0
    local endY = size
    local realX = math.Remap(x, startX, endX, -mapBounds, mapBounds)
    local realY = math.Remap(y, startY, endY, mapBounds, -mapBounds)
    return Vector(realX, realY, 0)
end

hook.Add("Think", "MapToggle", function()
    if input.IsKeyDown(KEY_M) and not MapOpen and not vgui.CursorVisible() then
        gui.EnableScreenClicker(true)
        MapOpen = true
        MapOpenTime = CurTime()
    elseif not input.IsKeyDown(KEY_M) and MapOpen then
        gui.EnableScreenClicker(false)
        MapOpen = false
        MapCloseTime = CurTime()
    end
end)

local function GetAlphaMultiplier()
    if MapOpen then
        return Lerp((CurTime() - MapOpenTime) / 0.1, 0, 1)
    else
        return Lerp((CurTime() - MapCloseTime) / 0.1, 1, 0)
    end
end

local TEAM_COLOR = Color(0, 255, 0)
local mat_player = Material("icons/player_marker.png", "noclamp smooth")
local function DrawPlayers()
    local pl = LocalPlayer()
    local pos = pl:GetPos()
    local scaling = 2
    local x, y = PosToMap(pos)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(mat_player)
    surface.DrawTexturedRectRotated(x, y, 20 * scaling, 20 * scaling, pl:GetAngles().y - 90)
    if TeamsIndex then
        local players = player.GetAll()
        for i = 1, #players do
            local other = players[i]
            if other == pl then continue end
            if not other:Alive() then continue end
            if not TeamsIndex[other:SteamID64()] then continue end
            local pos = other:GetPos()
            local x, y = PosToMap(pos)
            draw.SimpleTextOutlined("•", "16px", x, y, TEAM_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
            draw.SimpleTextOutlined(other:Nick(), "16px", x, y - 16 * scaling, TEAM_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
        end
    end
end

local DeathMaterial = Material("death.png")
local function DrawDeathPos()
    local pos = DeathPos
    if not pos then return end
    local scaling = 2
    local size = 48 * scaling
    local x, y = PosToMap(pos)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(DeathMaterial)
    surface.DrawTexturedRect(x - size * 0.5, y - size, size, size)
end

--[[ 
New marker system:
- A left mouse click on the open map will add a marker.
- A right mouse click will remove the most recent marker.
]]--
local markers = {}
local markerIcon = Material("icons/waypoint.png", "noclamp smooth")
local SETTING_COLOR = Color(41, 145, 29)

local function DrawMarkers()
    for k, marker in ipairs(markers) do
        local x, y = PosToMap(marker.pos)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(markerIcon)
        local markerSize = 20
        surface.DrawTexturedRectRotated(x, y, markerSize, markerSize, 0)
        
        -- Draw text with a shadow effect
        draw.SimpleTextOutlined(marker.label, "gRust.Overhead", x, y - markerSize, 
            SETTING_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
    end
end


local MapMaterial = Material("map.png")
local function CreateMap()
    if IsValid(Map) then Map:Remove() end
    Map = vgui.Create("Panel")
    Map:SetSize(ScrW(), ScrH())
    Map:Center()
    Map.Paint = function(me)
        local alpha = GetAlphaMultiplier() * 255
        me:SetAlpha(alpha)
        if alpha == 0 then return end
        local size = ScrH()
        surface.SetDrawColor(90, 85, 63)
        surface.DrawRect(0, 0, ScrW(), ScrH())
        surface.SetDrawColor(255, 255, 255, alpha)
        surface.SetMaterial(MapMaterial)
        surface.DrawTexturedRect(ScrW() * 0.5 - size * 0.5, 0, size, size)
        DrawDeathPos()
        DrawPlayers()
        DrawMarkers() -- draw the custom markers
    end

    -- Handle mouse clicks to add/remove markers
    Map.OnMousePressed = function(self, key)
        if key == MOUSE_LEFT then
            local mx, my = self:CursorPos()
            local markerPos = MapToPos(mx, my)
            table.insert(markers, { pos = markerPos, label = "Marker" })
        elseif key == MOUSE_RIGHT then
            table.remove(markers) -- removes the most recent marker
        end
    end
end

CreateMap()
