print("[gRust] Loaded")
local Scr_W, Scr_H = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "gAchivements.structure", function(oldWidth, oldHeight) 
    Scr_W, Scr_H = ScrW(), ScrH() 
end)

surface.CreateFont("StringFont2", {
    font = "Roboto",
    size = 15,
    weight = 700
})

-- Common inventory styling and positioning constants
local INVENTORY_CONFIG = {
    SLOT_SIZE = 85,
    SLOT_MARGIN = 5,
    GRID_COLS = 6,
    GRID_ROWS = 5,
    BACKGROUND_COLOR = Color(80, 76, 70, 180),
    TEXT_COLOR = Color(255, 255, 255),
    PANEL_POSITION = {x = 0.5, y = 0.5} -- Center position (will be calculated based on screen size)
}

-- Categories for crafting
local CRAFTING_CATEGORIES = {
    {name = "Favorite", icon = "icons/favorite_inactive.png"},
    {name = "Construction", icon = "icons/construction.png"},
    {name = "Items", icon = "icons/extinguish.png"},
    {name = "Resources", icon = "icons/servers.png"},
    {name = "Clothing", icon = "icons/servers.png"},
    {name = "Tools", icon = "icons/tools.png"},
    {name = "Medical", icon = "icons/medical.png"},
    {name = "Weapons", icon = "icons/weapon.png"},
    {name = "Ammo", icon = "icons/ammo.png"},
    {name = "Fun", icon = "icons/servers.png"},
    {name = "Other", icon = "icons/electric.png"}
}

local inventoryPanel = nil
local hotbarPanel = nil
local inventorySlots = {}
local hotbarSlots = {}

-- Function to create a model panel for an item
local function CreateItemModelPanel(parent, itemData)
    local modelPanel = vgui.Create('DModelPanel', parent)
    modelPanel:SetModel(itemData.Mdl)
    modelPanel:Dock(FILL)
    
    if itemData.Skins then 
        modelPanel.Entity:SetSkin(itemData.Skins) 
    end
    
    local mins, maxs = modelPanel.Entity:GetRenderBounds()
    modelPanel:SetCamPos(mins:Distance(maxs) * Vector(0.8, 0.8, 0.5))
    modelPanel:SetLookAt((maxs + mins) / 2)
    
    function modelPanel:LayoutEntity(ent)
        if self:GetParent().Hovered then 
            ent:SetAngles(Angle(0, ent:GetAngles().y + 2, 0)) 
        end
    end
    
    modelPanel.DoClick = function() 
        print(itemData.Mdl, itemData.Name) 
    end
    
    return modelPanel
end

-- Function to create an inventory slot
local function CreateInventorySlot(parent, x, y, width, height)
    local slot = vgui.Create("DPanel", parent)
    slot:SetPos(x, y)
    slot:SetSize(width, height)
    slot:Droppable("gDrop")
    
    slot.Paint = function(self, w, h)
        surface.SetDrawColor(INVENTORY_CONFIG.BACKGROUND_COLOR)
        surface.DrawRect(0, 0, w, h)
    end
    
    return slot
end

local function UpdateSlotWithItem(slot, itemData)
    -- More thorough cleanup
    slot:Clear() -- This is more reliable than manually iterating children
    
    -- If we have item data, add the model and information
    if itemData and itemData.Name and itemData.Name ~= "" then
        -- Create model panel
        local modelPanel = CreateItemModelPanel(slot, itemData)
        
        -- Add item name and amount at the bottom
        local infoText = itemData.Name
        if itemData.Amount and itemData.Amount > 1 then
            infoText = infoText .. " +" .. itemData.Amount
        end

        -- Draw an overlay panel if the weapon is active
        if itemData.WepClass and itemData.WepClass ~= "" then
            local activeWep = LocalPlayer():GetActiveWeapon()
            if IsValid(activeWep) and activeWep:GetClass() == itemData.WepClass then
                local highlight = vgui.Create("DPanel", slot)
                highlight:SetSize(slot:GetWide(), slot:GetTall())
                highlight:SetPos(0, 0)
                highlight.Paint = function(self, w, h)
                    draw.RoundedBox(8, 0, 0, w, h, Color(42, 101, 147, 100))
                end
            end
        end

        -- Add item label
        local itemInfo = vgui.Create("DLabel", slot)
        itemInfo:SetText(infoText)
        itemInfo:SetFont("StringFont2")
        itemInfo:SetTextColor(INVENTORY_CONFIG.TEXT_COLOR)
        itemInfo:SizeToContents()
        itemInfo:SetPos(5, slot:GetTall() - itemInfo:GetTall() - 5)
    end
end



-- Function to create and display the main inventory
local function CreateInventoryPanel(itemData)
    if inventoryPanel and inventoryPanel:IsValid() then
        inventoryPanel:Remove()
    end
    
    -- Calculate centered position
    local panelWidth = (INVENTORY_CONFIG.SLOT_SIZE + INVENTORY_CONFIG.SLOT_MARGIN) * INVENTORY_CONFIG.GRID_COLS + INVENTORY_CONFIG.SLOT_MARGIN
    local panelHeight = (INVENTORY_CONFIG.SLOT_SIZE + INVENTORY_CONFIG.SLOT_MARGIN) * INVENTORY_CONFIG.GRID_ROWS + INVENTORY_CONFIG.SLOT_MARGIN + 30 -- +30 for header
    local posX = (Scr_W - panelWidth) * INVENTORY_CONFIG.PANEL_POSITION.x
    local posY = (Scr_H - panelHeight) * INVENTORY_CONFIG.PANEL_POSITION.y
    
    -- Create main panel
    inventoryPanel = vgui.Create("DPanel")
    inventoryPanel:SetSize(panelWidth, panelHeight)
    inventoryPanel:SetPos(posX, posY)
    inventoryPanel:Droppable("gDrop")
    
    inventoryPanel.Paint = function(self, w, h)
        surface.SetDrawColor(80, 76, 70, 130)
        surface.DrawRect(0, 0, w, h)
        
        -- Draw header
        surface.SetDrawColor(60, 56, 50, 255)
        surface.DrawRect(0, 0, w, 30)
        draw.DrawText("Inventory", "StringFont2", 10, 7, INVENTORY_CONFIG.TEXT_COLOR, TEXT_ALIGN_LEFT)
    end
    
    -- Create inventory grid
    local grid = vgui.Create("DGrid", inventoryPanel)
    grid:SetPos(INVENTORY_CONFIG.SLOT_MARGIN, 30 + INVENTORY_CONFIG.SLOT_MARGIN)
    grid:SetCols(INVENTORY_CONFIG.GRID_COLS)
    grid:SetColWide(INVENTORY_CONFIG.SLOT_SIZE + INVENTORY_CONFIG.SLOT_MARGIN)
    grid:SetRowHeight(INVENTORY_CONFIG.SLOT_SIZE + INVENTORY_CONFIG.SLOT_MARGIN)
    
    -- Create slots
    inventorySlots = {}
    for i = 1, INVENTORY_CONFIG.GRID_COLS * INVENTORY_CONFIG.GRID_ROWS do
        local slot = CreateInventorySlot(nil, 0, 0, INVENTORY_CONFIG.SLOT_SIZE, INVENTORY_CONFIG.SLOT_SIZE)
        inventorySlots[i] = slot
        grid:AddItem(slot)
        
        -- Add item if available
        if itemData and itemData[i] then
            UpdateSlotWithItem(slot, itemData[i])
        end
    end
    
    return inventoryPanel
end

-- Function to create and display the hotbar
local function CreateHotbarPanel(hotbarData)
    if hotbarPanel and hotbarPanel:IsValid() then
        hotbarPanel:Remove()
    end
    
    -- Calculate dimensions for hotbar (6 slots)
    local slotCount = 6
    local panelWidth = (INVENTORY_CONFIG.SLOT_SIZE + INVENTORY_CONFIG.SLOT_MARGIN) * slotCount + INVENTORY_CONFIG.SLOT_MARGIN
    local panelHeight = INVENTORY_CONFIG.SLOT_SIZE + INVENTORY_CONFIG.SLOT_MARGIN * 2
    
    -- Position at bottom center of screen
    local posX = (Scr_W - panelWidth) / 2
    local posY = Scr_H * 0.85
    
    hotbarPanel = vgui.Create("DPanel")
    hotbarPanel:SetSize(panelWidth, panelHeight)
    hotbarPanel:SetPos(posX, posY)
    
    hotbarPanel.Paint = function(self, w, h)
        -- Transparent background
        surface.SetDrawColor(0, 0, 0, 0)
        surface.DrawRect(0, 0, w, h)
    end
    
    -- Create hotbar slots
    hotbarSlots = {}
    for i = 1, slotCount do
        local x = INVENTORY_CONFIG.SLOT_MARGIN + (i-1) * (INVENTORY_CONFIG.SLOT_SIZE + INVENTORY_CONFIG.SLOT_MARGIN)
        local slot = CreateInventorySlot(hotbarPanel, x, INVENTORY_CONFIG.SLOT_MARGIN, INVENTORY_CONFIG.SLOT_SIZE, INVENTORY_CONFIG.SLOT_SIZE)
        hotbarSlots[i] = slot
        
        -- Add item if available
        if hotbarData and hotbarData[i] then
            UpdateSlotWithItem(slot, hotbarData[i])
        end
    end
    
    return hotbarPanel
end

-- Handle main inventory data
net.Receive("ForgiveMeInventory", function()
    local itemData = net.ReadTable()
    CreateInventoryPanel(itemData)
end)

-- Handle hotbar data
net.Receive("UpdateRustHud", function()
    local hotbarData = net.ReadTable()
    CreateHotbarPanel(hotbarData)
end)

local invOpened = false

net.Receive("UpdateRustInv", function()
    if invOpened then
        local hotbarData = net.ReadTable()
        CreateInventoryPanel(hotbarData)
    end
end)

-- Open/close inventory with spawn menu
hook.Add("OnSpawnMenuOpen", "OpenInventory", function()
    net.Start("SendInventory")
    net.SendToServer()
    invOpened = true
end)

hook.Add("OnSpawnMenuClose", "CloseInventory", function() 
    if inventoryPanel and inventoryPanel:IsValid() then
        inventoryPanel:Remove()
        invOpened = false
    end
end)