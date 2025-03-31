local PANEL = {}
function PANEL:Init()
    self.Panel = vgui.Create("DPanel", self)
    self.Panel.Paint = function(panel, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(48, 48, 48, 255)) end
    self.Button_logo = vgui.Create("DImage", self)
    self.Button_logo:SetImage("gments/gmod.png")
    self.DLabel = vgui.Create("DLabel", self)
    self.DLabel:SetText("gRust Inventory")
    self.DLabel:SetFont("Trebuchet24")
    self.DLabel:SizeToContents()
    self.Button = vgui.Create("DImageButton", self)
    self.Button:SetSize(32, 32)
    self.Button:SetImage("gments/cross.png")
    self.Button.DoClick = function()
        self:Remove()
        gui.EnableScreenClicker(false)
    end

    gui.EnableScreenClicker(true)
    self.PanelLeft = vgui.Create("DPanel", self)
    self.PanelLeft.Paint = function(panel, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(116, 185, 255)) end
    self.PanelLeftr = vgui.Create("DPanel", self)
    self.PanelLeftr.Paint = function(panel, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(48, 48, 48)) end
    self.Button_logo2 = vgui.Create("DImage", self.PanelLeftr)
end

function PANEL:PerformLayout()
    self.Button:SetPos(self:GetWide() - 31 - 4, 0)
    self.Panel:SetPos(0, 0)
    self.Panel:SetSize(self:GetWide(), 35)
    self.DLabel:SetPos(40, 5)
    self.Button_logo:SetPos(0, 0)
    self.Button_logo:SetSize(32, 34)
    self.PanelLeftr:Dock(LEFT)
    self.PanelLeftr:SetSize(self:GetWide(), self:GetTall())
    self.PanelLeftr:DockMargin(0, 35, 0, 0)
    self.PanelLeft:Dock(LEFT)
    self.PanelLeft:SetSize(200, self:GetTall())
    self.PanelLeft:DockMargin(0, 35, 0, 0)
end

function PANEL:AddItem(pnl, item)
    if self.button:GetText() == "Inventory" then end
end

function PANEL:AddButton(text, imgn, func)
    self.button = vgui.Create("DButton", self.PanelLeft)
    self.button:Dock(TOP)
    self.button:SetText("")
    self.button:SetTall(40)
    self.button.Paint = function(s, w, h)
        if not s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(52, 152, 219))
        else
            draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185))
        end

        draw.DrawText(text, "Trebuchet24", w * 0.2, h * 0.2, Color(255, 255, 255), TEXT_ALIGN_LEFT)
    end

    self.button.DoClick = function(val)
        if self.PanelLeft then
            self.PanelLeftr:Remove()
            self.PanelLeftr = vgui.Create("DPanel", self)
            self.PanelLeftr.Paint = function(panel, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(48, 48, 48)) end
        end

        func(self.PanelLeftr, val, text)
    end

    local img = vgui.Create("DImage", self.button)
    img:SetImage(imgn)
    img:SetPos(self.button:GetWide() * 0.1, self.button:GetTall() * 0.2)
    img:SetSize(24, 24)
    if text == "Inventory" then func(self.PanelLeftr, nil, "Inventory") end
end

vgui.Register("gRust_Panel", PANEL, "DPanel")