local function HUDHide(myhud)
    for k, v in pairs{'CHudHealth', 'CHudBattery', 'CHudAmmo', 'CHudDeathNotice', 'CHUDQuickInfo', 'CHudHintDisplay'} do
        if myhud == v then return false end
    end
end

hook.Add('HUDShouldDraw', 'HudHide', HUDHide)
surface.CreateFont("StringFont", {
    font = "Roboto",
    size = 23,
    weight = 700
})
 
local start, oldhp, newhp = 0, -1, -1
local barW = 200
local animationTime = 0.9
local startar, oldar, newar = 0, -1, -1
local BarMove = 0
local testmterial = Material("icons/health.png")
local armor = Material("icons/cup.png")
local hungr = Material("icons/medical.png")
local function hud()
    local ply = LocalPlayer()
    local hp = LocalPlayer():Health()
    local maxhp = LocalPlayer():GetMaxHealth()
    local color_blue = Color(74, 159, 221)
    local color_g = Color(150, 198, 62)
    local color_b = Color(49, 47, 42, 225)
    local color_h = Color(217, 135, 79)
    local ar = LocalPlayer():Armor()
    local scrw = ScrW()
    local scrh = ScrH()
    local smoothHP = Lerp((SysTime() - start) / animationTime, oldhp, newhp)
    local smoothAR = Lerp((SysTime() - startar) / animationTime, oldar, newar)
    if hp <= 0 then return end
    if oldhp == -1 and newhp == -1 then
        oldhp = hp
        newhp = hp
    end

    if newhp ~= hp then
        if smoothHP ~= hp then newhp = smoothHP end
        oldhp = newhp
        start = SysTime()
        newhp = hp
    end

    if newar ~= ar then
        if smoothAR ~= ar then newar = smoothAR end
        oldar = newar
        startar = SysTime()
        newar = ar
    end

    draw.RoundedBoxEx(15, ScrW() - 306, scrh - 162, 238, 32, color_b, false, false, false, false)
    draw.RoundedBoxEx(15, ScrW() - 270, scrh - 159, math.Clamp(0, 100, smoothHP) / maxhp * barW, 25, color_g, false, false, false, false)
    draw.SimpleText(hp, "StringFont", ScrW() - 270, scrh - 159, color_white)

    draw.RoundedBoxEx(15, ScrW() - 306, scrh - 128, 238, 32, color_b, false, false, false, false)
    draw.RoundedBoxEx(15, ScrW() - 270, scrh - 125, math.Clamp(0, 100, smoothAR) * 2, 25, color_blue, false, false, false, false)
    draw.SimpleText(ar, "StringFont", ScrW() - 270, scrh - 125, color_white)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(testmterial)
    surface.DrawTexturedRect(ScrW() - 303, scrh - 160, 25, 25)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(armor)
    surface.DrawTexturedRect(ScrW() - 303, scrh - 125, 30, 30)
    local tr = LocalPlayer():GetEyeTrace().Entity
    if not tr and tr:GetPos():Distance2DSqr(LocalPlayer():GetPos()) <= 50 then return end
    if string.find(tr:GetClass(), "sent") and not string.find(tr:GetClass(), "sent_rock") then
        local posying = tr:GetPos():ToScreen()
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(testmterial)
        surface.DrawTexturedRect(posying.x - 103, posying.y - 160, 25, 25)
        draw.DrawText(tostring(math.Round(tr:GetNWInt("health_" .. tr:GetClass()))), "StringFont", posying.x - 63, posying.y - 160, Color(255, 255, 255))
    end
    --[[local wep = ply:GetActiveWeapon()
    if !IsValid(wep) or !ply:Alive() or !wep:IsWeapon() then 
        return 
    else
        draw.RoundedBoxEx( 15, 164, scrh - 94,  90, 32, color_b, false, false, false, false )
        draw.SimpleText( wep:Clip1() .. '/' .. ply:GetAmmoCount(wep:GetPrimaryAmmoType()), 'StringFont', 210, scrh-80, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end]]
end

hook.Add('HUDPaint', 'rhud', hud)