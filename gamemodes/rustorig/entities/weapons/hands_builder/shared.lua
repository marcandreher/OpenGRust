AddCSLuaFile()
if CLIENT then
    SWEP.Author = "BleueBear"
    SWEP.Slot = 3
    SWEP.SlotPos = 0
    SWEP.IconLetter = "b"
    killicon.AddFont("hands_builder", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.Base = "weapon_base"
SWEP.PrintName = "Builder"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "gRust"
SWEP.UseHands = true
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/darky_m/rust/w_hammer.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.HoldType = "ar2"
SWEP.LoweredHoldType = "passive"
SWEP.Primary.Sound = Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Damage = 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.002
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.08
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(-6.6, -15, 2.6)
SWEP.IronSightsAng = Vector(2.6, -1, 0)
SWEP.HasIron = false
SWEP.DrawAmmo = false
if SERVER then
    util.AddNetworkString("EntSndToServer_By_Foundation")
    util.AddNetworkString("gRust_ServerModel")
end

if SERVER then
    net.Receive("EntSndToServer_By_Foundation", function(l, ply)
        local RdVec = net.ReadVector()
        local RdAng = net.ReadFloat()
        local models = net.ReadString()
        ply.ReadVec = RdVec
        --print(ply.ReadVec)
        ply.ReadAng = RdAng
        ply.ReadAngx = RdAngx
        ply.ReadModel = models
    end)

    --print( ply.ReadAng )
    net.Receive("gRust_ServerModel", function(l, pl)
        local rs = net.ReadString()
        pl.ModelFN = rs or "sent_foundation"
    end)
end

local SlotTaken = {}
local function Ture(ply)
    for k, v in pairs(SlotTaken) do
        for k1, v1 in pairs(ents.FindInSphere(v, 1)) do
            if v1:GetClass() == "sent_foundation" then
                if v1:GetPos() == ply.ReadVec then
                    v1:Remove()
                    table.remove(SlotTaken, k1)
                end
            end
        end
    end
end

local function IWasHereFirst(ply)
    if not table.HasValue(SlotTaken, ply.ReadVec) then table.insert(SlotTaken, ply.ReadVec) end
    local aassda = false
    for i, jpg in pairs(ents.FindInSphere(ply.ReadVec, 0.1)) do
    end
    return aassda
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(true) end
    self:SetNextPrimaryFire(CurTime() + 0.4)
    self:SendWeaponAnim(ACT_VM_SWINGHIT) --/ACT_VM_SWINGMISS)   
    self:SetAnimation(PLAYER_ATTACK1)
    if SERVER then
        local ply = self:GetOwner()
        if not IsValid(ply) then return end
        if ply:HasEnoughVood(25) then
            local Pos, Angl
            local Position = math.Round(360 - ply:GetAngles().y % 360)
            local twig = ents.Create(self.Owner.ModelFN or "sent_foundation")
            twig:SetModel(ply.ReadModel)
            twig:SetPos(ply.ReadVec)
            twig:SetAngles(Angle(0, ply.ReadAng, 0))
            twig:Spawn()
            twig:Activate()
            twig.PropOwned = ply
            constraint.Weld(twig, Entity(0), 0, 0, 0, false, false)
            for i, jpg in pairs(ents.FindInSphere(ply.ReadVec, 0.1)) do
                if twig:GetPos() == jpg then v:Remove() end
            end

            ply:EmitSound("building/hammer_saw_1.wav")
            ply:DeductVood(25)
        end

        
        -- end
        --ply:EmitSound("zohart/building/hammer-saw-1.wav")
    end

    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(false) end
end

function SWEP:SecondaryAttack()
    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(true) end
    if self.CD == nil then self.CD = 0 end
    if self.CD >= CurTime() then return end
    self.CD = CurTime() + 1
    self:GetOwner():ConCommand("+azrm_showmenu")
    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(false) end
end

if CLIENT then
    Map = Map or {}
    Map.Str = ""
    --print( str, Map.Str )
    function SWEP:Deploy()
        local ply = self:GetOwner()
        --if IsValid( ply ) then
        --print( Map.Str )
        -- end
    end

    local function IsStandingOn(ent, what)
        for k, v in pairs(ents.FindInSphere(ent:GetPos(), 50)) do
            --print(v:GetPos():Distance(ent:GetPos())) // v:GetPos():Distance(ent:GetPos()) <= 50 and
            if v:GetPos():Distance(ent:GetPos()) <= 150 and v:GetClass() == what then --print( v )
               // print(v:GetClass(), what, v)
                return v
            end
        end
        return nil
    end

    local hooks_key = -120
    hook.Add("Think", "TestyBoobyTest", function()
        local eye_trace = LocalPlayer():GetEyeTrace()
        if not eye_trace then return end
        --local posz = math.Round(4 - eye_trace.HitPos.z % 4)
        --hooks_key = posz
    end)

    local up = 0
    local Timer_s_grust = 0
    hook.Add("PlayerButtonDown", "hands_builder", function(ply, key)
        local wep = ply:GetActiveWeapon()
        if not wep:IsValid() then return end
        if wep:GetClass() ~= "hands_builder" then return end
        if key == 15 and Timer_s_grust < CurTime() then
            Timer_s_grust = CurTime() + 0.5
            --if up >= -80 then up = 0 end
            --up = up + 10
            --hooks_key = up
        end
    end)

    local Nests = {
        ["sent_foundation"] = {
            Model = "models/building/twig_foundation.mdl", --"models/building/floor.mdl",
            Class = "sent_foundation",
            funct = function(own, ent)
                local entOnGround = own:GetGroundEntity()
                local Pos, Angl = nil, nil
                --if IsValid( entOnGround ) then
                -- print(entOnGround:GetClass() )
                local tr = util.TraceLine({
                    start = own:EyePos() + EyeAngles():Forward() * 180,
                    endpos = own:EyePos() + EyeAngles():Forward() * 200,
                })

                --end
                local StandingOnFD = IsStandingOn(own, "sent_foundation")
                if not IsValid(StandingOnFD) then
                    if entOnGround ~= NULL and entOnGround:GetClass() ~= "sent_foundation" then
                        if EyeAngles():Up().z <= 0.98 then
                            Pos = tr.HitPos * tr.HitPos:Angle():Up().z * -50
                            Angl = own:GetAngles()
                            return Pos, Angl
                        end

                        Pos = tr.HitPos
                        Angl = own:GetAngles()
                        return Pos, Angl
                    end
                    return
                end

                local Position = math.Round(360 - own:GetAngles().y % 360)
                if not IsValid(entOnGround) then return end
                local owne = own:GetEyeTrace()
                if not owne then return end
                local edgy = 130
                local obbmin = entOnGround:OBBMaxs()
                local whatthen = obbmin.z - 15
                if Position >= 1 and Position <= 40 or Position >= 320 and Position <= 360 then
                    Pos = Vector(entOnGround:GetPos().x + edgy, entOnGround:GetPos().y, entOnGround:GetPos().z + whatthen)
                    Angl = 0
                elseif Position > 50 and Position < 120 then
                    Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y - edgy, entOnGround:GetPos().z + whatthen)
                    Angl = 270
                elseif Position > 146 and Position < 217 then
                    Pos = Vector(entOnGround:GetPos().x - edgy, entOnGround:GetPos().y, entOnGround:GetPos().z + whatthen)
                    Angl = 0
                elseif Position > 234 and Position < 310 then
                    Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y + edgy, entOnGround:GetPos().z + whatthen)
                    Angl = 270
                end
                return Pos, Angl
            end
        },
        ["sent_wall"] = {
            Model = "models/building_re/twig_wall.mdl",
            Class = "sent_wall",
            funct = function(own, ent)
                local entOnGround = own:GetGroundEntity()
                local Pos, Angl = nil, nil
                if not entOnGround then return end
                local StandingOnFD = IsStandingOn(own, "sent_foundation")
                if not IsValid(StandingOnFD) then return end
                local Position = math.Round(360 - own:GetAngles().y % 360)
                if not IsValid(entOnGround) then return end
                local obbcentre = ent:OBBMins()
                local obbcentrem = ent:OBBMaxs()
                local vec = entOnGround:GetPos() - entOnGround:GetPos()
                vec.z = obbcentrem.z
                local owne = own:GetEyeTrace()
                if not owne.Entity then return end
                --print(Position)
                --Vector( entOnGround:GetPos().x + 60, entOnGround:GetPos().y, entOnGround:GetPos().z )  entOnGround:GetPos().z * 
                local posyx = 60
                local ups = 0
                local obbmin = entOnGround:GetPos().z + entOnGround:OBBMaxs().z
                if Position >= 1 and Position <= 40 or Position >= 320 and Position <= 360 then
                    Pos = Vector(entOnGround:GetPos().x + posyx, entOnGround:GetPos().y, obbmin)
                    Angl = 270
                elseif Position > 50 and Position < 120 then
                    Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y - posyx, obbmin)
                    Angl = 0
                elseif Position > 146 and Position < 217 then
                    Pos = Vector(entOnGround:GetPos().x - posyx, entOnGround:GetPos().y, obbmin)
                    Angl = 270
                elseif Position > 234 and Position < 310 then
                    Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y + posyx, obbmin)
                    Angl = 0
                end
                return Pos, Angl
            end
        },
        ["sent_doorway"] = {
            Model = "models/building_re/twig_dframe.mdl",
            Class = "sent_doorway",
            funct = function(own, ent)
                local entOnGround = own:GetGroundEntity()
                local Pos, Angl = nil, nil
                if not entOnGround then return end
                local StandingOnFD = IsStandingOn(own, "sent_foundation")
                if not IsValid(StandingOnFD) then return end
                local Position = math.Round(360 - own:GetAngles().y % 360)
                if not IsValid(entOnGround) then return end
                local ups = 0
                local obbmin = entOnGround:GetPos().z + entOnGround:OBBMaxs().z
                if Position >= 1 and Position <= 40 or Position >= 320 and Position <= 360 then
                    Pos = Vector(entOnGround:GetPos().x + 60, entOnGround:GetPos().y, obbmin) --entOnGround:GetPos().z +
                    Angl = 270
                elseif Position > 50 and Position < 120 then
                    Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y - 70, obbmin)
                    Angl = 0
                elseif Position > 146 and Position < 217 then
                    Pos = Vector(entOnGround:GetPos().x - 60, entOnGround:GetPos().y, obbmin)
                    Angl = 270
                elseif Position > 234 and Position < 310 then
                    Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y + 70, obbmin)
                    Angl = 0
                end
                return Pos, Angl
            end
        },
        ["sent_door"] = {
            Model = "models/vasey/wood_house/door.mdl",
            Class = "sent_door",
            funct = function(own, ent)
                local entOnGround = own:GetGroundEntity()
                local Pos, Angl = nil, nil
                if not entOnGround then return end
                local StandingOnFD = IsStandingOn(own, "sent_foundation")
                if not IsValid(StandingOnFD) then return end
                local Position = math.Round(360 - own:GetAngles().y % 360)
                if not IsValid(entOnGround) then return end
                local ups = 0
                local obbmin = entOnGround:GetPos().z + entOnGround:OBBMaxs().z
                if Position >= 1 and Position <= 40 or Position >= 320 and Position <= 360 then
                    Pos = Vector(entOnGround:GetPos().x + 60, entOnGround:GetPos().y, obbmin)
                    Angl = 0
                elseif Position > 50 and Position < 120 then
                    Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y - 70, obbmin)
                    Angl = 270
                elseif Position > 146 and Position < 217 then
                    Pos = Vector(entOnGround:GetPos().x - 60, entOnGround:GetPos().y, obbmin)
                    Angl = 0
                elseif Position > 234 and Position < 310 then
                    Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y + 70, obbmin)
                    Angl = 270
                end
                return Pos, Angl
            end
        },
        ["sent_ceiling"] = {
            Model = "models/building_re/twig_floor.mdl",
            Class = "sent_ceiling",
            funct = function(own, ent)
                local entOnGround = own:GetGroundEntity()
                local Pos, Angl = nil, nil
                if not entOnGround then return end
                local StandingOnFD = IsStandingOn(own, "sent_foundation")
                if not IsValid(StandingOnFD) then return end
                local Position = math.Round(360 - own:GetAngles().y % 360)
                if not IsValid(entOnGround) then return end
                local obbcentre = ent:OBBMins()
                local obbcentrem = ent:OBBMaxs()
                local vec = entOnGround:GetPos() - entOnGround:GetPos()
                vec.z = obbcentrem.z
                local owne = own:GetEyeTrace()
                if not owne.Entity then return end
                --print(Position)
                --Vector( entOnGround:GetPos().x + 60, entOnGround:GetPos().y, entOnGround:GetPos().z )  entOnGround:GetPos().z * 
                local posyx = 80
                local ups = 120
                local obbmin = entOnGround:GetPos().z + entOnGround:OBBMaxs().z
                Pos = Vector(entOnGround:GetPos().x, entOnGround:GetPos().y, obbmin + ups)
                Angl = 0
                return Pos, Angl
            end
        },
    }

    local GhostEntity = nil
    hook.Add("Think", "whatamidoing", function()
        local wep = LocalPlayer():GetActiveWeapon()
        if not IsValid(wep) then return end
        if wep:GetClass() ~= "hands_builder" then
            if IsValid(GhostEntity) then GhostEntity:Remove() end
            GhostEntity = nil
            return
        end
    end)

    function SWEP:DrawHUD()
        local ply = self:GetOwner()
        if not IsValid(ply) then return end
        if Map.Str == "" then
            Map.Str = "sent_foundation"
            return
        end

        local Posi, Angl = Nests[Map.Str].funct(ply, ply:GetEyeTrace().Entity)
        if Posi == nil and Angl == nil then return end
        draw.DrawText(tostring(Posi), "DermaDefault", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    end

    local ins_gurst_log = {}
    function SWEP:Think()
        if not GhostEntity then GhostEntity = ents.CreateClientProp() end
        if not IsValid(GhostEntity) then
            GhostEntity = nil
            return
        end

        local ply = self:GetOwner()
        local eyet = ply:GetEyeTrace()
        --if not eyet and not ply then return end
        --print( Map.Str )
        if Map.Str ~= "" then
            local model = Nests[Map.Str].Model
            local Posi, Angl = Nests[Map.Str].funct(ply, ply:GetEyeTrace().Entity, GhostEntity)
            if Posi == nil and Angl == nil then return end
            self.Ply = self:GetOwner()
            self.Pos = Posi
            self.ang = Angl
            GhostEntity:SetModel(model)
            --print(Posi,Angl)
            --if not table.HasValue(ins_gurst_log, Posi) then table.insert(ins_gurst_log, Posi) end
            local entOnGround = ply:GetGroundEntity()
            --* self.Ply:GetEyeTrace().HitPos.x, self.Ply:GetEyeTrace().HitPos.y, self.Ply:GetEyeTrace().HitPos.z )
            if entOnGround ~= NULL and entOnGround:GetClass() ~= "sent_foundation" then
                GhostEntity:SetPos(Posi)
                GhostEntity:SetAngles(Angle(0, Angl, 0))
                net.Start("EntSndToServer_By_Foundation")
                net.WriteVector(Posi) -- 3.99 ) ) - Vector( self.Ply:GetEyeTrace().HitPos.x, self.Ply:GetEyeTrace().HitPos.y, self.Ply:GetEyeTrace().HitPos.z )
                net.WriteFloat(0)
                net.WriteString(model)
                net.SendToServer()
            else
                GhostEntity:SetPos(Posi)
                GhostEntity:SetAngles(Angle(0, Angl, 0))
                net.Start("EntSndToServer_By_Foundation")
                net.WriteVector(Posi)
                net.WriteFloat(tonumber(Angl))
                net.WriteString(model)
                net.SendToServer()
                --print( Angl )
            end

            GhostEntity:Spawn()
            GhostEntity:PhysicsDestroy()
            GhostEntity:SetMoveType(MOVETYPE_NONE)
            GhostEntity:SetNotSolid(true)
            --GhostEntity:SetRenderMode(RENDERMODE_NONE)
            if self.Ply:GetPos():Distance(self.Ply:GetEyeTrace().HitPos) >= 27 and self.Ply:GetPos():Distance(self.Ply:GetEyeTrace().HitPos) <= 30 and EyeAngles():Up().z <= 0.98 then
                GhostEntity:SetColor(Color(255, 0, 0, 255))
            else
                GhostEntity:SetColor(Color(47, 47, 255))
            end
        end
    end
end