print("[gRust] Loaded")
local Scr_W, Scr_H = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "gAchivements.structure", function(oldWidth, oldHeight)
    Scr_W, Scr_H = ScrW(), ScrH()
end)
local panelHovered = 0
-- Create fonts
surface.CreateFont("StringFont2", {
    font = "Roboto",
    size = 15,
    weight = 700
})

surface.CreateFont("RustTitle", {
    font = "Roboto",
    size = 24,
    weight = 700
})

surface.CreateFont("RustText", {
    font = "Roboto",
    size = 15,
    weight = 500
})

surface.CreateFont("MyFont", {
    font = "Arial",
    extended = false,
    size = 23,
    weight = 500,
})

-- Category definitions - keep original structure
local Tbl = {}
Tbl[1] = {"Favorite", "icons/favorite_inactive.png"}
Tbl[2] = {"Construction", "icons/construction.png"}
Tbl[3] = {"Items", "icons/extinguish.png"}
Tbl[4] = {"Resources", "icons/servers.png"}
Tbl[5] = {"Clothing", "icons/servers.png"}
Tbl[6] = {"Tools", "icons/tools.png"}
Tbl[7] = {"Medical", "icons/medical.png"}
Tbl[8] = {"Weapons", "icons/weapon.png"}
Tbl[9] = {"Ammo", "icons/ammo.png"}
Tbl[11] = {"Fun", "icons/servers.png"}
Tbl[12] = {"Other", "icons/electric.png"}

-- Variables from original code
local vgui_New
local text_to_glow = ""
local Paneln_Crafttb = {}
local DLabel = nil
local DLabel2 = nil
local Panel2b = nil
local Panel2bc = nil
local Panel2bcc = nil
local Panel5 = nil
local Panel2bcn = nil
local invw = {}
invw.SlotPos = 15
invw.Storage = 0

Crafting2 = Crafting2 or {}
local Panelnb = {}

-- Network functionality with fixed countdown timing
net.Receive("gRust_Queue_Crafting2_Timer", function()
    local timerz = net.ReadFloat() -- expected to be CurTime() + duration
    local img = net.ReadString()
    local txt = net.ReadString()
    local num = net.ReadFloat()
    local fndnum = net.ReadFloat()
    
    Paneln_Crafttb[#Paneln_Crafttb + 1] = {
        pnl = Paneln_Craft,
        Image = img,
        Text = txt,
        Timer = timerz,
    }

    if table.Count(Paneln_Crafttb) > 0 and IsValid(Panel5) then
        for k, v in pairs(Paneln_Crafttb) do
            local Panel2basdsad = vgui.Create("DPanel", Panel5)
            Panel2basdsad:Dock(LEFT)
            Panel2basdsad:SetSize(150, Panel5:GetTall())
            
            local Panel2bc = vgui.Create("DPanel", Panel2basdsad)
            Panel2bc:SetSize(150, Panel2basdsad:GetTall())
            
            local modelPanel = vgui.Create("DModelPanel", Panel2bc)
            modelPanel:SetSize(150, Panel2bc:GetTall() - 10)
            
            local fnd = string.find(v.Image, ".mdl")
            if fnd ~= nil then
                modelPanel:SetModel(v.Image)
            else
                modelPanel:SetModel(weapons.Get(v.WepClass).WorldModel)
            end

            function modelPanel:LayoutEntity(Entity)
                return
            end

            local PrevMins, PrevMaxs = modelPanel.Entity:GetRenderBounds()
            modelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.15) + Vector(0, 0, 5))
            modelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
            
            modelPanel.Paint = function(s, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 10, Color(50, 50, 50, 150))
                local timeLeft = math.Round(v.Timer - CurTime())
                draw.DrawText(v.Text .. " Timeleft: " .. tostring(timeLeft), "Default", Panel2bc:GetWide() * 0.05, 70, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                if timeLeft <= 0 then Panel2basdsad:Remove() end
            end
        end
    end
end)

-- Preserve the original AddItemPanel_2 function with added hover outline
function AddItemPanel_2(txt, Craft, CancelCraft, where, img, num, newpnl, timers, rightpnl, info, inf, amt, inf2, amt2, your_amt, modelz)
    for k, v in pairs(GMRustTable) do
        if v.Where == where and v.name == txt then
            Panelnb[num] = vgui.Create("DModelPanel")
            Panelnb[num].Text = v.name
            Panelnb[num].Clause = v.Where
            Panelnb[num].locked = false
            Panelnb[num]:SetText("")
            Panelnb[num]:SetSize(100, 100)
            Panelnb[num]:SetModel(modelz)
            Panelnb[num].LayoutEntity = function(Entity) return end
            
            local PrevMins, PrevMaxs = Panelnb[num].Entity:GetRenderBounds()
            Panelnb[num]:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.15) + Vector(0, 0, 5))
            Panelnb[num]:SetLookAt((PrevMaxs + PrevMins) / 2)
            Panelnb[num].ColumnNumber = k
            
            local time = CurTime() + 60
            
            -- Preserve original click functionality
            Panelnb[num].DoClick = function()
                if IsValid(Panel2b) then Panel2b:Remove() end
                if IsValid(DLabel) then DLabel:Remove() end
                if IsValid(Panel2bc) then Panel2bc:Remove() end
                if IsValid(DLabel2) then DLabel2:Remove() end
                if IsValid(Panel2bcc) then Panel2bcc:Remove() end
                if IsValid(Panel2bcn) then Panel2bcn:Remove() end
                
                -- Right panel item details
                Panel2b = vgui.Create("DPanel", rightpnl)
                Panel2b:Dock(TOP)
                Panel2b:SetSize(150, newpnl:GetTall())
                Panel2b.Paint = function(s, w, h) 
                    draw.RoundedBox(0, 0, 0, w, h - 10, Color(60, 60, 60, 200)) 
                end
                
                -- Item name label
                DLabel = vgui.Create("DLabel", rightpnl)
                DLabel:SetPos(Panel2b:GetWide() * 0.5, 40)
                DLabel:SetFont("RustTitle")
                DLabel:SetText(txt)
                DLabel:SetTextColor(Color(255, 255, 255))
                DLabel:SizeToContents()
                
                -- Item description panel
                Panel2bc = vgui.Create("DPanel", rightpnl)
                Panel2bc:Dock(TOP)
                Panel2bc:SetSize(150, 80)
                Panel2bc.Paint = function(s, w, h) 
                    draw.RoundedBox(0, 0, 0, w, h - 10, Color(60, 60, 60, 0)) 
                end
                
                -- Item description text
                DLabel2 = vgui.Create("DLabel", Panel2bc)
                DLabel2:SetPos(rightpnl:GetWide() * 0.1, 10)
                DLabel2:SetFont("RustText")
                DLabel2:SetText(info)
                DLabel2:SetTextColor(Color(200, 200, 200))
                DLabel2:SizeToContents()
                
                -- Requirements panel
                Panel2bcc = vgui.Create("DPanel", rightpnl)
                Panel2bcc:Dock(TOP)
                Panel2bcc:SetSize(150, 150)
                Panel2bcc.Paint = function(s, w, h) 
                    draw.RoundedBox(0, 0, 0, w, h - 10, Color(50, 50, 50, 200)) 
                end
                
                -- Requirements list
                local AppList = vgui.Create("DListView", Panel2bcc)
                AppList:Dock(FILL)
                AppList:SetMultiSelect(false)
                AppList:AddColumn("Need")
                AppList:AddColumn("Item Type")
                AppList:AddColumn("Your Wood/Amount")
                AppList:AddColumn("Your Amount")
                
                if inf2 ~= "" then
                    AppList:AddLine(amt, inf, your_amt .. "/" .. amt, your_amt)
                    AppList:AddLine(amt, inf2, your_amt .. "/" .. amt2, your_amt)
                else
                    AppList:AddLine(amt, inf, your_amt .. "/" .. amt, your_amt)
                end

                AppList.OnRowSelected = function(lst, index, pnl) 
                    print("Selected " .. pnl:GetColumnText(1) .. " ( " .. pnl:GetColumnText(2) .. " ) at index " .. index) 
                end
                
                -- Craft button panel
                Panel2bcn = vgui.Create("DPanel", rightpnl)
                Panel2bcn:Dock(BOTTOM)
                Panel2bcn:SetSize(150, 100)
                Panel2bcn.Paint = function(s, w, h) 
                    draw.RoundedBox(0, 0, 0, w, h - 10, Color(50, 50, 50, 0)) 
                end
                
                -- Craft button with hover effect
                Paneln_Craft = vgui.Create("DButton", Panel2bcn)
                Paneln_Craft:SetText("CRAFT")
                Paneln_Craft:SetFont("RustTitle")
                Paneln_Craft:SetPos(Panel2bcn:GetWide() * 0.7, Panel2bcn:GetTall() * 0.2)
                Paneln_Craft:SetWide(100)
                Paneln_Craft:SetTall(50)
                Paneln_Craft:SetTextColor(Color(255, 255, 255))
                Paneln_Craft.Paint = function(s, w, h)
                    local btnColor = Color(80, 80, 80, 255)
                    if s:IsHovered() then
                        btnColor = Color(34, 139, 34, 255)
                    end
                    draw.RoundedBox(0, 0, 0, w, h, btnColor)
                end
                
                -- Craft functionality (unchanged)
                Paneln_Craft.DoClick = function()
                    if not LocalPlayer():HasEnoughVood(amt) and GetConVar("grust_debug") == 0 then
                        LocalPlayer():PrintMessage(HUD_PRINTCENTER, "Cannot afford")
                        return
                    end
                    Craft(Panelnb[num].Text, num)
                    print("Crafting item")
                end
            end

            -- Right-click functionality remains unchanged
            Panelnb[num].DoRightClick = function() 
                CancelCraft(Panelnb[num].Text) 
            end

            -- Add hover outline using PaintOver so the model is still rendered
            Panelnb[num].PaintOver = function(self, w, h)
                if self:IsHovered() then
                    surface.SetDrawColor(34,139,34,255)
                    surface.DrawOutlinedRect(0, 0, w, h)
                end
            end
        end
    end
    return Panelnb[num]
end

-- Main crafting function - updated with Rust-style visuals and added hover effects
local function Crafting2()
    gui.EnableScreenClicker(true)
    
    -- Main panel
    Panel = vgui.Create("DPanel")
    Panel:SetPos(50, 50)
    Panel:SetSize(ScrW() - 100, ScrH() - 100)
    Panel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 240))
    end
    Panel:Center()
    
    -- Header with title
    local Header = vgui.Create("DPanel", Panel)
    Header:Dock(TOP)
    Header:SetTall(50)
    Header.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 200))
        draw.SimpleText("CRAFTING", "RustTitle", w/2, h/2, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        -- Back arrow
        surface.SetDrawColor(200, 200, 200)
        surface.SetMaterial(Material("icon16/arrow_left.png"))
        surface.DrawTexturedRect(20, h/2 - 8, 16, 16)
    end
    
    -- Content panel (maintains original layout with updated visuals)
    Panel2 = vgui.Create("DPanel", Panel)
    Panel2:SetPos(0, 51)
    Panel2:SetSize(Panel:GetWide(), Panel:GetTall() - 51)
    Panel2.Paint = function(s, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 0)) 
    end
    
    -- Categories panel
    Panel3 = vgui.Create("DPanel", Panel2)
    Panel3:SetPos(0, 1)
    Panel3:SetSize(Panel2:GetWide() / 5, Panel2:GetTall() - 100)
    Panel3.Paint = function(s, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200)) 
    end
    
    -- Items grid panel
    Panel4 = vgui.Create("DPanel", Panel2)
    Panel4:SetPos(Panel3:GetWide() + 10, 1)
    Panel4:SetSize(Panel2:GetWide() / 2.5, Panel2:GetTall() - 100)
    Panel4.Paint = function(s, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200)) 
    end
    
    -- Crafting queue panel
    Panel5 = vgui.Create("DPanel", Panel)
    Panel5:Dock(BOTTOM)
    Panel5:SetSize(Panel:GetWide(), 80)
    Panel5.Paint = function(s, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200)) 
    end
    
    -- Crafting queue header
    local QueueHeader = vgui.Create("DPanel", Panel)
    QueueHeader:SetPos(0, Panel:GetTall() - 120)
    QueueHeader:SetSize(Panel:GetWide(), 40)
    QueueHeader.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
        draw.SimpleText("CRAFTING QUEUE", "RustTitle", 20, h/2, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    -- Right details panel
    Panel6 = vgui.Create("DPanel", Panel2)
    Panel6:SetPos(Panel4:GetPos() + Panel4:GetWide() + 10, 1)
    Panel6:SetSize(Panel2:GetWide() - Panel3:GetWide() - Panel4:GetWide() - 20, Panel2:GetTall() - 100)
    Panel6.Paint = function(s, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200)) 
    end
    
    -- Create item grid
    local grid = vgui.Create("DGrid", Panel4)
    grid:SetPos(10, 30)
    grid:SetCols(5)
    grid:SetColWide(102)
    grid:SetRowHeight(102)
    
    -- Maintain crafting queue panel functionality with fixed countdown
    if table.Count(Paneln_Crafttb) > 0 then
        for k, v in pairs(Paneln_Crafttb) do
            local Panel2basdsad = vgui.Create("DPanel", Panel5)
            Panel2basdsad:Dock(LEFT)
            Panel2basdsad:SetSize(150, Panel5:GetTall())
            
            local Panel2bc = vgui.Create("DPanel", Panel2basdsad)
            Panel2bc:SetSize(150, Panel2basdsad:GetTall())
            
            local modelPanel = vgui.Create("DModelPanel", Panel2bc)
            modelPanel:SetSize(150, Panel2bc:GetTall() - 10)
            
            local fnd = string.find(v.Image, ".mdl")
            if fnd ~= nil then
                modelPanel:SetModel(v.Image)
            else
                modelPanel:SetModel(weapons.Get(v.WepClass).WorldModel)
            end

            function modelPanel:LayoutEntity(Entity)
                return
            end

            local PrevMins, PrevMaxs = modelPanel.Entity:GetRenderBounds()
            modelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.15) + Vector(0, 0, 5))
            modelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
            
            modelPanel.Paint = function(s, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 10, Color(50, 50, 50, 150))
                local timeLeft = math.Round(v.Timer - CurTime())
                draw.DrawText(v.Text .. " Timeleft: " .. tostring(timeLeft), "Default", Panel2bc:GetWide() * 0.05, 70, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                if timeLeft <= 0 then Panel2basdsad:Remove() end
            end
        end
    end
    
    -- Category buttons - updated with hover and green highlight effects
    local Paneln = {}
    for i, new in SortedPairs(Tbl) do
        Paneln[i] = vgui.Create("DButton", Panel3)
        Paneln[i]:SetText("")
        Paneln[i]:Dock(TOP)
        Paneln[i]:SetTall(45)
        Paneln[i]:DockPadding(22, 0, 0, 2)
        
        Paneln[i].Paint = function(s, w, h)
            local bgColor = Color(60, 60, 60, 100)
            if s:IsHovered() then
                bgColor = Color(34, 139, 34, 150)
            end
            if panelHovered == i then
                bgColor = Color(34, 139, 34, 150)
            end
            draw.RoundedBox(0, 0, 0, w, h, bgColor)
            
            local textColor = (text_to_glow == new[1]) and Color(255, 255, 255) or Color(200, 200, 200)
            draw.DrawText(new[1], "RustText", s:GetWide() * 0.45, 15, textColor, TEXT_ALIGN_CENTER)
        end
        
        -- Reset item panels before loading new ones
        local itm = {}
        for k, v in pairs(GMRustTable) do
            v.locked = false
        end
        
        Paneln[i].DoClick = function(self)
            panelHovered = i
            for k, v in pairs(Panelnb) do
                if IsValid(v) then v:Remove() end
            end
            
            table.Empty(Panelnb)
            
            for k, v in pairs(GMRustTable) do
                text_to_glow = v.Where
                if IsValid(itm[k]) then return end
                
                if v.need2 == nil then
                    itm[k] = AddItemPanel_2(v.name, v.func, v.gotob, new[1], v.img, k, Panel5, 
                        CurTime() + v.timers + 1, Panel6, v.Infomation, v.need[1].txt, 
                        v.need[1].amt, "", "", tostring(LocalPlayer():GetNWFloat("wood", 0)), v.Mdl)
                else
                    itm[k] = AddItemPanel_2(v.name, v.func, v.gotob, new[1], v.img, k, Panel5, 
                        CurTime() + v.timers + 1, Panel6, v.Infomation, v.need[1].txt, 
                        v.need[1].amt, v.need[1].txt, v.need[1].amt, 
                        tostring(LocalPlayer():GetNWFloat("wood", 0)), v.Mdl)
                end
                
                v.locked = true
                grid:AddItem(itm[k])
            end
        end
        
        -- Category icon
        local img = Paneln[i]:Add("DImage")
        img:SetImage(new[2])
        img:Dock(LEFT)
        img:SetTall(32)
        img:SetWide(32)
        img:SetImageColor(Color(255, 255, 255))
    end
    

end

-- Maintain original hooks
hook.Add("ScoreboardShow", "Scoreboard_Open", function()
    Crafting2()
    return true
end)

hook.Add("ScoreboardHide", "Scoreboard_Close", function()
    if IsValid(Panel) then Panel:Remove() end
    gui.EnableScreenClicker(false)
    panelHovered = 0
    return true
end)
