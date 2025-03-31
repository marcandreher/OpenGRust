AddCSLuaFile()
if CLIENT then
    SWEP.Author = "BleueBear"
    SWEP.Slot = 3
    SWEP.SlotPos = 0
    SWEP.IconLetter = "b"
    killicon.AddFont("hands_builder", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.Base = "weapon_base"
SWEP.PrintName = "Hammer"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "gRust"
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/darky_m/rust/c_hammer.mdl"
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
function SWEP:Initialize()
    self:SetHoldType("melee")
end

net.Receive("gRust_ServerModel_new", function(l, pl) pl.What = net.ReadString() end)
local rotation = -90
function SWEP:PrimaryAttack()
    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(true) end
    self:SetNextPrimaryFire(CurTime() + 1)
    self:SendWeaponAnim(ACT_VM_SWINGHIT) --/ACT_VM_SWINGMISS)   
    self:SetAnimation(PLAYER_ATTACK1)
    local et_own = self:GetOwner()
    local et = et_own:GetEyeTrace().Entity
    local Build = {
        {
            sent = "sent_foundation",
            Model = "models/galaxy/rust/wood_foundation.mdl", --"models/building/wood_foundation.mdl"
        },
        {
            sent = "sent_wall",
            Model = "models/building/wood_wall.mdl"
        },
        {
            sent = "sent_ceiling",
            Model = "models/building/wood_floor.mdl"
        },
        {
            sent = "sent_doorway",
            Model = "models/building/wood_dframe.mdl"
        }
    }

    if et_own.What == "Rotate" then
        if et:GetClass() == "sent_door" then return end
        if rotation >= 180 then rotation = -90 end
        rotation = rotation + -90
        et:SetAngles(Angle(0, rotation, 0))
    end

    if et_own.What == "Wood" and self:GetOwner():GetNWFloat("wood", 0) >= 50 then
        if et and string.find(et:GetClass(), "sent_") then
            for k, v in pairs(Build) do --models/galaxy/rust/wood_foundation.mdl
                if v.sent == et:GetClass() then
                    if v.sent == "sent_foundation" then
                        local spawn = ents.Create(v.sent)
                        local obbmin = et:OBBMins()
                        spawn:SetModel(v.Model)
                        spawn:SetPos(et:GetPos() + Vector(0, 0, obbmin.z))
                        spawn:Spawn()
                        spawn:Activate()
                        constraint.Weld(spawn, Entity(0), 0, 0, 0, false, false)
                        spawn.Ent_Health = 1000
                        spawn.Ent_HealthMax = 1000
                        spawn.PropOwned = self:GetOwner()
                        et:Remove()
                    else
                        et:SetModel(v.Model)
                    end
                end
            end

            et_own:EmitSound("building/hammer_saw_1.wav")
            self:GetOwner():DeductVood(50)
        end
    elseif et_own.What == "Stone" and string.find(et:GetClass(), "sent_") then
        --[[if et then
           
            et_own:EmitSound( "building/rust_stone_1.wav" )
            et.Ent_Health = 1500
            et.Ent_HealthMax = 1500
        end
    elseif et_own.What == "Metal" and string.find( et:GetClass(), "sent_" ) then
        if et then
   
            et_own:EmitSound( "building/rust_metal_2.wav" )
            et.Ent_Health = 2500
            et.Ent_HealthMax = 2500
        end]]
    end

    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(false) end
    --phoenix_storms/metalfloor_2-3 HQM
end

function SWEP:SecondaryAttack()
    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(true) end
    self:SetNextSecondaryFire(CurTime() + 1)
    self:GetOwner():ConCommand("+azrm_showmenu")
    if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(false) end
end