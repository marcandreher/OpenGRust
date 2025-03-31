-- Network strings
util.AddNetworkString("SendInventory")
util.AddNetworkString("ForgiveMeInventory")
util.AddNetworkString("Craft_BP")
util.AddNetworkString("UpdateRustHud")
util.AddNetworkString("UpdateRustInv")

-- Constants
local MaxInventory = 42
local INVENTORY_PATH = "ginv"

-- Find player metatable once
local meta = FindMetaTable("Player")

-- Helper functions
local function GetInventoryPath(steamid64)
    return INVENTORY_PATH .. "/inventory_" .. steamid64 .. ".txt"
end

local function EnsureInventoryDir()
    if not file.IsDir(INVENTORY_PATH, "DATA") then
        file.CreateDir(INVENTORY_PATH)
    end
end

function IsInventoryFull(ply)
    local count = 0
    for k, v in pairs(ply.inv) do
        count = count + 1
    end
    return count >= MaxInventory
end

function GetAmmoForCurrentWeapon(ply)
    if not IsValid(ply) then
        return -1
    end
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then
        return -1
    end
    return ply:GetAmmoCount(wep:GetPrimaryAmmoType())
end

-- Player meta functions
function meta:FirstCreateInv(b_Alive)
    b_Alive = b_Alive or ""
    EnsureInventoryDir()

    local filePath = GetInventoryPath(self:SteamID64())
    if not file.Exists(filePath, "DATA") or b_Alive == "b_dead" then
        file.Write(filePath, util.TableToJSON({}))
    end

    local inv = util.JSONToTable(file.Read(filePath, "DATA"))
    net.Start("SendInventory")
    net.WriteTable(inv)
    net.Send(self)

    return inv
end

function meta:GetInventory()
    local filePath = GetInventoryPath(self:SteamID64())
    if file.Exists(filePath, "DATA") then
        return util.JSONToTable(file.Read(filePath, "DATA"))
    end
    return NULL
end

function meta:ClearInventory()
    self.inv = {}

    self:UpdateInventory()

    self:SaveInventory(self.inv)

    for _, weapon in ipairs(self:GetWeapons()) do
        weapon:Remove()
    end

    return NULL
end


function meta:UpdateInventory()
    net.Start("UpdateRustHud")
    net.WriteTable(self.inv)
    net.Send(self)
    
    return NULL
end

function meta:GetItem(item)
    local inv = self:GetInventory()
    if inv == NULL then
        return 0
    end

    for k, v in pairs(inv) do
        if v.Name == item then
            return v
        end
    end
end

function meta:SaveInventory(inv)
    file.Write(GetInventoryPath(self:SteamID64()), util.TableToJSON(inv))
end

-- Find first available slot or slot with same item class
local function FindSlot(inv, itemClass)
    local slots = {}

    for i = 1, MaxInventory do
        if inv[i] == nil or inv[i].Class == itemClass then
            table.insert(slots, i)
        end
    end

    return #slots > 0 and slots[1] or nil
end

-- Cooldown management
local cooldowns = {
    addItem = 0,
    addWep = 0,
    give = 0
}

function meta:AddToInventory(item)
    if cooldowns.addItem >= CurTime() then
        return
    end
    cooldowns.addItem = CurTime() + 1

    local inv = self.inv or {}
    local slot = FindSlot(inv, item:GetClass())

    if not slot then
        print("No available slots.")
        return
    end

    local amount = math.random(3, 5)
    local altered = false

    -- Check if item already exists in inventoryf
    for k, v in pairs(inv) do
        if v.Class == item:GetClass() then
            amount = v.Amount + amount
            altered = true
            break
        end
    end

    -- Create item data
    inv[slot] = {
        Name = item.Name,
        Class = item:GetClass() or "",
        WepClass = item:GetClass() or "",
        Mdl = item:GetModel() or "",
        Ammo_New = GetAmmoForCurrentWeapon(self) or 0,
        Amount = amount or 0
    }

    self:SaveInventory(inv)
end

function meta:AddWepInventory(item)
    if cooldowns.addWep >= CurTime() then
        return
    end
    cooldowns.addWep = CurTime() + 1

    local inv = self.inv or {}
    local slot = FindSlot(inv, item:GetClass())

    if not slot then
        print("No available slots.")
        return
    end

    inv[slot] = {
        Name = item.PrintName,
        Class = item:GetClass() or "",
        WepClass = item:GetClass() or "",
        Mdl = item:GetModel() or "",
        Ammo_New = GetAmmoForCurrentWeapon(self) or 0,
        Amount = 1
    }

    self:SaveInventory(inv)
end

function meta:RemoveWepInventory(item)
    local inv = self.inv or {}

    for k, v in pairs(inv) do
        if v.Class == item:GetClass() then
            inv[k] = nil
        end
    end

    self.inv = inv
    self:SaveInventory(inv)
end

-- Resource management functions
function meta:AddToInventoryWood(amt)
    local inv = self.inv or {}
    local altered = false

    for k, v in pairs(inv) do
        if v.Class == "rust_wood" then
            v.Amount = v.Amount + amt
            self:SetNWFloat("wood", v.Amount)
            altered = true
            break
        end
    end

    if not altered then
        table.insert(inv, {
            Name = "Wood",
            Class = "rust_wood",
            WepClass = "rust_wood",
            Mdl = "models/props_debris/wood_board04a.mdl",
            Ammo_New = GetAmmoForCurrentWeapon(self) or 0,
            Amount = amt
        })
        self:SetNWFloat("wood", amt)
    end

    self.inv = inv
    self:SaveInventory(inv)
end

function meta:RemoveInventoryWood(amt)
    local inv = self.inv or {}

    for k, v in pairs(inv) do
        if v.Class == "rust_wood" then
            v.Amount = v.Amount - amt

            if v.Amount > 0 then
                self:SetNWFloat("wood", v.Amount)
            else
                inv[k] = nil
                self:SetNWFloat("wood", 0)
            end

            break
        end
    end

    self.inv = inv
    self:SaveInventory(inv)
end

local function GetRockName(skinId)
    if skinId == 1 then
        return "Metal"
    elseif skinId == 2 then
        return "Sulfur"
    else
        return "Rock"
    end
end

function meta:AddToInventoryRocks(skinId)
    local inv = self.inv or {}
    local amount = math.random(25, 30)
    local altered = false

    for k, v in pairs(inv) do
        if v.Class == "sent_rocks" and v.Skins == skinId then
            v.Amount = v.Amount + amount
            altered = true
            break
        end
    end

    if not altered then
        table.insert(inv, {
            Name = GetRockName(skinId),
            Class = "sent_rocks",
            WepClass = "sent_rocks",
            Mdl = "models/environment/ores/ore_node_stage1.mdl",
            Ammo_New = GetAmmoForCurrentWeapon(self) or 0,
            Amount = amount,
            Skins = skinId
        })
    end

    self.inv = inv
    self:SaveInventory(inv)
end

function meta:RemoveInventoryRocks(skinId, amt)
    local inv = self.inv or {}

    for k, v in pairs(inv) do
        if v.Class == "sent_rocks" and v.Skins == skinId then
            v.Amount = v.Amount - amt

            if v.Amount <= 0 then
                inv[k] = nil
            end

            break
        end
    end

    self.inv = inv
    self:SaveInventory(inv)
end

-- Override Give function
local oldGive = meta.Give
function meta:Give(item, bAmmo)
    if not item or item == "" then
        return
    end

    if cooldowns.give >= CurTime() then
        return
    end
    cooldowns.give = CurTime() + 1

    oldGive(self, item, bAmmo or false)

    local wep = self:GetWeapon(item)
    if IsValid(wep) then
        self:AddWepInventory(wep)
    end
end

-- Net receive functions
net.Receive("Craft_BP", function(len, ply)
    local str = net.ReadString()
    ply.bp = BluePrint_Get(str)

    print("[Open GRust] [" .. ply:Nick() .. "] Trying crafting item " .. str)

    -- TODO: Resource check implementation is incomplete in original code

    timer.Create("Create" .. tostring(str), ply.bp.timers, 0, function()
        ply:Give(ply.bp.Class)
        timer.Remove("Create" .. tostring(str))
        print("[Open GRust] [" .. ply:Nick() .. "] Crafted item " .. str)
    end)
end)

net.Receive("SendInventory", function(len, ply)
    if not ply.CoolDowngrust then
        ply.CoolDowngrust = 0
    end
    if ply.CoolDowngrust >= CurTime() then
        return
    end

    ply.CoolDowngrust = CurTime() + 1
    net.Start("ForgiveMeInventory")
    net.WriteTable(ply.inv)
    net.Send(ply)
end)

local load_queue = {}

hook.Add("PlayerInitialSpawn", "UpdateRustSpawnHook", function(ply)
    load_queue[ply] = true
end)

hook.Add("StartCommand", "UpdateRustHookStartHook", function(ply, cmd)
    if load_queue[ply] and not cmd:IsForced() then
        load_queue[ply] = nil

        net.Start("UpdateRustHud")
        net.WriteTable(ply.inv)
        net.Send(ply)
    end
end)

-- Hooks
local function BackwardsEnums(enumname)
    local backenums = {}
    for k, v in pairs(_G) do
        if isstring(k) and string.find(k, "^" .. enumname) then
            backenums[v] = k
        end
    end
    return backenums
end

hook.Add("EntityTakeDamage", "EntityDamageExample", function(ent, dmginfo)
    local MAT = BackwardsEnums("MAT_")
    local ply = dmginfo:GetAttacker()

    if not IsValid(ply) then
        return
    end

    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then
        return
    end

    local toolClass = wep:GetClass()
    local isTool = string.find(toolClass, "hatchet") or string.find(toolClass, "pickaxe") or
                       string.find(toolClass, "rock")
    local changed = false
    if isTool and MAT[ent:GetMaterialType()] == "MAT_WOOD" then
        ply:AddToInventoryWood(5)
        changed = true
    end

    if ent:GetClass() == "sent_rocks" then
        ply:AddToInventoryRocks(ent:GetSkin())
        changed = true
    end

    if changed then
        net.Start("UpdateRustHud")
        net.WriteTable(ply.inv)
        net.Send(ply)
        net.Start("UpdateRustInv")
        net.WriteTable(ply.inv)
        net.Send(ply)
    end
end)

hook.Add("PlayerDroppedWeapon", "RemoveWepFromInv", function(owner, wep)
    owner:RemoveWepInventory(wep)
end)

hook.Add("PlayerInitialSpawn", "InventoryLoadout", function(ply)
    ply.inv = ply:FirstCreateInv()

    for k, v in pairs(ents.FindInSphere(ply:GetPos(), 10)) do
        if v:GetClass() == "sent_rocks" then
            ply:SetPos(v:GetPos() + Vector(v:OBBMins().x, v:OBBMins().y, v:OBBMins().z + 12))
        end
    end

    local plymeta = ply:GetItem("Wood")
    if plymeta then
        ply:SetNWFloat("wood", plymeta.Amount)
    end
end)

hook.Add("PlayerSpawn", "GiveITems", function(ply)
    ply.inv = ply:FirstCreateInv()

    for k, v in pairs(ents.FindByClass("rust_sleepingbag")) do
        if v.Owner == ply then
            ply:SetPos(v.GetPosz + Vector(0, 0, 10))
        end
    end

    for k, v in pairs(ents.FindInSphere(ply:GetPos(), 10)) do
        if v:GetClass() == "sent_rocks" then
            ply:SetPos(v:GetPos() + Vector(v:OBBMins().x, v:OBBMins().y, v:OBBMins().z + 12))
        end
    end

    local plymeta = ply:GetItem("Wood")
    if plymeta then
        ply:SetNWFloat("wood", plymeta.Amount)
    end
end)

hook.Add("PlayerDeath", "RemoveItems", function(ply)
    ply.inv = ply:FirstCreateInv("b_dead")
end)

hook.Add("PlayerUse", "USeInventory", function(ply, ent)
    if ent.IsItem == true then
        ply:AddToInventory(ent)
        ent:Remove()
    end
end)

hook.Add("GetFallDamage", "CSSFallDamage", function(ply, speed)
    return math.max(0, math.ceil(0.2418 * speed - 141.75))
end)

