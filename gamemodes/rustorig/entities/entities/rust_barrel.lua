AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
if SERVER then util.AddNetworkString("GibBreak") end
local BarrelTypes = {
	{
		Health = 35,
		Color = Color(200, 165, 115),
		Bodygroup = 0
	},
	{
		Health = 50,
		Color = Color(80, 120, 205),
		Bodygroup = 0
	},
	{
		Health = 50,
		Color = Color(170, 62, 60),
		Bodygroup = 1
	}
}

function ENT:Initialize()
	if CLIENT then return end
	self:SetModel("models/environment/misc/barrel_v2.mdl")
	self:PhysicsInitStatic(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetHealth(50)
	self:SetMaxHealth(50)
	self:SetBodygroup(1, math.random(0, 1))
	self:PrecacheGibs()
	self.Type = BarrelTypes[math.random(#BarrelTypes)]
	self:SetHealth(self.Type.Health)
	self:SetMaxHealth(self.Type.Health)
	self:SetColor(self.Type.Color)
	self:SetBodygroup(1, self.Type.Bodygroup)
	self.Time = 0
end

local LootItems = {
	{
		Item = "rust_scrap",
		Min = 2,
		Max = 2,
		Chance = 100,
		BarrelColor = Color(200, 165, 115),
	},
}

local function GetRandomItem(tbl)
	for i = 1, #tbl do
		local v = tbl[i]
		if (math.random() * 100) > v.Chance then continue end
		local Item = v.Item
		table.remove(tbl, i)
		return Item
	end
end

function ENT:RecoveryTime(pos)
	if self.Time == nil then self.Time = 0 end
	if CurTime() <= self.Time then return end
	self.Time = CurTime() + 5
	timer.Simple(60 * math.random(28, 32), function()
		local ent = ents.Create("rust_barrel")
		ent:SetPos(pos)
		ent:Spawn()
		ent:Activate()
	end)
end

function ENT:SpawnLoot()
	if CLIENT then return end
	tbl = table.Copy(LootItems)
	for i = 1, 5 do
		local Item = GetRandomItem(tbl)
		if not Item then continue end
		local Maxs = self:OBBMaxs()
		local ent = ents.Create(Item)
		ent:SetPos(self:GetPos() + Vector(math.random(-Maxs.x, Maxs.x), math.random(-Maxs.y, Maxs.y), Maxs.z * math.random(0.25, 0.5)))
		ent:Spawn()
		ent:Activate()
		ent:DropToFloor()
	end
end

function ENT:OnTakeDamage(dmg)
	if SERVER then
		self.Type.Health = self.Type.Health - dmg:GetDamage()
		if self.Type.Health <= 0 then
			self:SpawnLoot()
			self:RecoveryTime(self:GetPos())
			self:GibBreakClient(VectorRand() * 100)
			self:Remove()
		end
	end
end