SWEP.Base = "tfa_rustalpha_gunbase"
SWEP.Category = "TFA Rust Legacy"
SWEP.Author = "YuRaNnNzZZ"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.PrintName = "Torch" -- Weapon name (Shown on HUD)	
SWEP.Slot = 5 -- Slot in the weapon selection menu
SWEP.SlotPos = 0 -- Position in the slot
SWEP.DrawAmmo = false -- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox = false -- Should draw the weapon info box
SWEP.BounceWeaponIcon = false -- Should the weapon icon bounce?
SWEP.DrawCrosshair = false -- set false if you want no crosshair
SWEP.Weight = 2 -- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo = true -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom = true -- Auto switch from if you pick up a better weapon
SWEP.HoldType = "slam" -- how others view you carrying the weapon
SWEP.Type = "Portable Light Source"
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/yurie_rustalpha/c-vm-torch.mdl" -- Weapon view model
SWEP.WorldModel = "models/weapons/yurie_rustalpha/wm-torch-irp.mdl" -- Weapon world model
SWEP.Spawnable = (TFA_BASE_VERSION and TFA_BASE_VERSION >= 4.5) and (TFA and TFA.RUSTALPHA ~= nil)
SWEP.UseHands = true
SWEP.AdminSpawnable = true
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 0
SWEP.Primary.RPM = 0 -- This is in Rounds Per Minute
SWEP.Primary.ClipSize = -1 -- Size of a clip
SWEP.Primary.DefaultClip = -1 -- Bullets you start with
SWEP.Primary.Automatic = false -- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo = ""
SWEP.data = SWEP.data or {}
SWEP.data.ironsights = 0
SWEP.EventTable = {
    [ACT_VM_DRAW] = {
        {
            time = 0,
            type = "sound",
            value = Sound("YURIE_RUSTALPHA.Draw")
        },
        {
            time = 0,
            type = "lua",
            value = function(wep, vm)
                wep:StopSounds()
                wep:SetHasTorchGlowEffect(true)
                local efdata = EffectData()
                efdata:SetEntity(wep)
                efdata:SetOrigin(wep:GetPos())
                efdata:SetAttachment(1)
                TFA.Effects.Create("yurie_rustalpha_torchglow", efdata)
            end
        },
    },
}

SWEP.VMPos = Vector(2, 0, 5)
SWEP.VMAng = Vector(-12, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-12, 5, -6)
SWEP.Offset = {
    Pos = {
        Up = 0,
        Right = 2.5,
        Forward = 3.25,
    },
    Ang = {
        Up = 180,
        Right = 0,
        Forward = 180
    },
    Scale = 1
}

DEFINE_BASECLASS(SWEP.Base)
function SWEP:SetupDataTables(...)
    BaseClass.SetupDataTables(self, ...)
    self:NetworkVar("Bool", 12, "HasTorchGlowEffect")
end

function SWEP:Think2(...)
    if DynamicLight then
        if self:GetHasTorchGlowEffect() then
            self.DLight = self.DLight or DynamicLight(self:EntIndex(), false)
            if self.DLight then
                local attpos = (self:IsFirstPerson() and self:GetOwner():GetViewModel() or self):GetAttachment(1)
                self.DLight.pos = (attpos and attpos.Pos) and attpos.Pos or self:GetPos()
                self.DLight.r = 63
                self.DLight.g = 31
                self.DLight.b = 0
                self.DLight.decay = 1000
                self.DLight.brightness = 1
                self.DLight.size = 1024
                self.DLight.dietime = CurTime() + 1
            end
        elseif self.DLight then
            self.DLight.dietime = -1
        end
    end
    return BaseClass.Think2(self, ...)
end

function SWEP:StopSounds(vm)
    self:SetHasTorchGlowEffect(false)
    if self.DLight then self.DLight.dietime = -1 end
    if IsValid(self.GlowFXCSEnt) then
        self.GlowFXCSEnt.REMOVEME = true
        -- self.GlowFXCSEnt:Remove()
    end
end

function SWEP:OnDrop(...)
    self:StopSounds(self.OwnerViewModel)
    return BaseClass.OnDrop(self, ...)
end

function SWEP:OwnerChanged(...)
    self:StopSounds(self.OwnerViewModel)
    return BaseClass.OwnerChanged(self, ...)
end

function SWEP:Holster(...)
    local retval = BaseClass.Holster(self, ...)
    if retval then self:StopSounds() end
    return retval
end

function SWEP:PrimaryAttack()
    local userid = self.Owner
    local weapon = self.Weapon
    local tr = {}
    tr.start = userid:GetShootPos()
    tr.endpos = userid:GetShootPos() + userid:GetAimVector() * 50
    tr.filter = userid
    tr.mask = MASK_SHOT
    local trace = util.TraceLine(tr)
    weapon:SetNextPrimaryFire(CurTime() + 2.7)
    if trace.Hit then
        bullet = {}
        bullet.Num = 1
        bullet.Src = self.Owner:GetShootPos()
        bullet.Dir = self.Owner:GetAimVector()
        bullet.Spread = Vector(0, 0, 0)
        bullet.Tracer = 0
        bullet.Force = 10
        bullet.Damage = math.random(10, 20)
        userid:FireBullets(bullet)
        --userid:SetAnimation( PLAYER_ATTACK1 )
        weapon:SendWeaponAnim(ACT_DEPLOY) --ACT_VM_PRIMARYATTACK) --ACT_VM_SWINGHIT) //ACT_VM_PRIMARYATTACK
        --userid:SetAnimation(PLAYER_ATTACK1)
        weapon:EmitSound("weapons/fireaxe/fireaxe_impact1.wav")
    else
        weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
        weapon:SendWeaponAnim(ACT_VM_SWINGMISS)
    end
end

function SWEP:SecondaryAttack()
    return false
end