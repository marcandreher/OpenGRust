AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "tree"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Models = "models/blacksnow/rock_ore.mdl"
if SERVER then
    local matr = {"models/blacksnow/rust_rock", "models/blacksnow/rock_ore",}
    function ENT:Initialize()
        self.Entity:SetModel("models/environment/ores/ore_node_stage1.mdl") --"..math.random(1,4).."
        --self.Entity:SetMaterial( table.Random( matr ) )
        -- 1 metal, 2 sulfur, 3 rock
        self:SetSkin(math.random(1, 3))
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:EnableMotion(false)
        end

        constraint.Weld(self, Entity(0), 0, 0, 0, true, true)
        self.Ent_Health = 300
        --self:SetMaterial("Model/effects/vol_light001")
        self:DrawShadow()
        self.SpawnTime = 0
        self.EntCount = 0
    end

    function ENT:SpawnFunction(ply, tr)
        if not tr.Hit then return end
        local ent = ents.Create("sent_rocks")
        ent:SetPos(tr.HitPos + tr.HitNormal * 32)
        ent:Spawn()
        ent:Activate()
        return ent
    end

    function ENT:Think()
    end

    function ENT:RecoveryTime(pos)
        timer.Simple(3, --60 * math.random(28,32),
            function()
            local ent = ents.Create("sent_rocks")
            ent:SetPos(pos)
            ent:Spawn()
            ent:Activate()
        end)
    end

    function ENT:OnTakeDamage(dmg)
        local ply = dmg:GetAttacker()
        local wep = ply:GetActiveWeapon()
        if not IsValid(ply) then return end
        if not IsValid(self) then return end
        --[[if IsValid(ply) and IsValid(wep) and string.find(wep:GetClass(), "pickaxe") or string.find(wep:GetClass(), "rock") then
            -- 1 metal, 2 sulfur, 3 Rock
            if self.AttacksRock == nil then self.AttacksRock = 0 end
            if self:GetSkin() == 1 then
                ply.Counter_Metal = math.random(5, 9)
                ply:SetEnoughMetal(ply.Counter_Metal)
                AddToInventory(ply, {
                    Name = "Metal Ore",
                    WepClass = "none",
                    Mdl = "models/galaxy/rust/rockore1.mdl",
                    Ammo_New = "none",
                    Amount = ply:GetEnoughMetal(),
                }, true)

                net.Start("Sent_Vood")
                net.WriteBool(true)
                net.WriteString("Metal")
                net.WriteFloat(ply:GetEnoughMetal())
                net.Send(ply)
                ply.ResetTime = 0
                ply.NotHitting = true
            elseif self:GetSkin() == 2 then
                ply.Counter_Sulfur = math.random(5, 9)
                ply:SetEnoughSulfur(ply.Counter_Sulfur)
                AddToInventory(ply, {
                    Name = "Sulfur Ore",
                    WepClass = "none",
                    Mdl = "models/items/sulfur_ore.mdl",
                    Ammo_New = "none",
                    Amount = ply:GetEnoughSulfur(),
                }, true)

                net.Start("Sent_Vood")
                net.WriteBool(true)
                net.WriteString("Sulfur")
                net.WriteFloat(ply:GetEnoughSulfur())
                net.Send(ply)
                ply.ResetTime = 0
                ply.NotHitting = true
            elseif self:GetSkin() == 3 then
                ply.Counter_Stone = math.random(5, 9)
                ply:SetEnoughStone(ply.Counter_Stone)
                AddToInventory(ply, {
                    Name = "Stone",
                    WepClass = "none",
                    Mdl = "models/environment/ores/ore_node_stage4.mdl",
                    Ammo_New = "none",
                    Amount = ply:GetEnoughStone(),
                }, true)

                net.Start("Sent_Vood")
                net.WriteBool(true)
                net.WriteString("Stone")
                net.WriteFloat(ply:GetEnoughStone())
                net.Send(ply)
                ply.ResetTime = 0
                ply.NotHitting = true
            end

            ply:EmitSound("tools/rock_strike_1.mp3")
            self.AttacksRock = self.AttacksRock + 10
            if self.AttacksRock >= 100 then self.Entity:SetModel("models/environment/ores/ore_node_stage2.mdl") end
            if self.AttacksRock >= 150 then self.Entity:SetModel("models/environment/ores/ore_node_stage3.mdl") end
            if self.AttacksRock >= 200 then
                self:RecoveryTime(self:GetPos())
                self:Remove()
            end
        end]]
    end

    function ENT:Use(btn, ply)
    end

    function ENT:StartTouch(entity)
        return false
    end

    function ENT:EndTouch(entity)
        return false
    end

    function ENT:Touch(entity)
        return false
    end
end

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
    function ENT:Initialize()
    end

    function ENT:Draw()
        self:DrawModel()
    end
end