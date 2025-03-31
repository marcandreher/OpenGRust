SWEP.Author = "God"
SWEP.PrintName = "Rock" --name
SWEP.Purpose = "" --your swep's description
SWEP.Instructions = "" --How to use your Swep
SWEP.Spawnable = true --if it is for everyone to use
SWEP.AdminSpawnable = true --if it is admin only
SWEP.Base = "weapon_base" ---the base of the swep
SWEP.HoldType = "melee2" --holdtype
SWEP.ViewModel = "models/weapons/darky_m/rust/c_rock2.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/darky_m/rust/w_rock.mdl"
SWEP.Primary.Delay = 0.19 --How long your swep must wait before attacking again.
SWEP.Primary.Recoil = 0 --How much your swep will go back or kick when you attack.
SWEP.Primary.Damage = 23 --How much damage you do on an attack
SWEP.Primary.NumShots = 1 --How many bullets in one attack
SWEP.Primary.Cone = 0 --If the bullet will spread or not
SWEP.Primary.ClipSize = -1 --How much ammo you can hold in the swep
SWEP.Primary.DefaultClip = -1 --How much ammo you get when you use the swep
SWEP.Primary.Automatic = true --If it is SMG fire ( true) or pistol fire (false)
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Delay = 5.2 ----Same here, except for secondary .Please refer to the above.
SWEP.Secondary.Recoil = 13
SWEP.Secondary.Damage = 54
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
if SERVER then AddCSLuaFile("shared.lua") end
if CLIENT then
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.ViewModelFOV = 62
    SWEP.IconLetter = "Rock"
    killicon.AddFont("weapon_rock", "CSKillIcons", SWEP.IconLetter, Color(255, 245, 10, 255))
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
    draw.SimpleText(self.IconLetter, "Default", x + wide / 2, y + tall * 0.2, Color(255, 245, 10, 255), 1)
    draw.SimpleText(self.IconLetter, "Default", x + wide / 2 + math.Rand(-4, 4), y + tall * 0.2 + math.Rand(-14, 14), Color(255, 245, 10, math.Rand(10, 120)), 1)
    draw.SimpleText(self.IconLetter, "Default", x + wide / 2 + math.Rand(-4, 4), y + tall * 0.2 + math.Rand(-9, 9), Color(255, 245, 10, math.Rand(10, 120)), 1)
end

function SWEP:Initialize()
    util.PrecacheSound("weapons/fireaxe/fireaxe_impact1.wav")
    util.PrecacheSound("weapons/fireaxe/fireaxe_impact2.wav")
    util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
    self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
    if SERVER then self.Weapon:SetWeaponHoldType(self.HoldType) end
    return true
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
    weapon:SetNextPrimaryFire(CurTime() + 1.4)
    if trace.Hit then
        --userid:SetAnimation( PLAYER_ATTACK1 )
        weapon:SendWeaponAnim(ACT_VM_SWINGHIT)
        bullet = {}
        bullet.Num = 1
        bullet.Src = self.Owner:GetShootPos()
        bullet.Dir = self.Owner:GetAimVector()
        bullet.Spread = Vector(0, 0, 0)
        bullet.Tracer = 0
        bullet.Force = 10
        bullet.Damage = math.random(10, 20)
        userid:FireBullets(bullet)
        weapon:EmitSound("weapons/fireaxe/fireaxe_impact1.wav")
    else
        weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
        weapon:SendWeaponAnim(ACT_VM_SWINGMISS)
    end
end