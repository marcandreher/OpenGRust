AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
if SERVER then
	function ENT:Initialize()
		self:SetModel("models/items/scrappile.mdl")
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetHealth(50)
		self:SetMaxHealth(50)
		self:SetUseType(SIMPLE_USE)
		self.IsItem = true
		self.Name = "Scrap"
	end

	function ENT:Use(act, ply)
		/*AddToInventory(
			ply,
			{
				Name = "Scrap",
				WepClass = "none",
				Mdl = "models/environment/misc/loot_bag.mdl",
				Ammo_New = "none",
				Amount = math.random(5, 8),
			},
			true
		)*/
		//ply:AddToInventory(self:GetClass())
		//self:Remove()
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end
