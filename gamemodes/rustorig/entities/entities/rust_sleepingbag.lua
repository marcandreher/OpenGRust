AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
	if CLIENT then return end
	self:SetModel("models/galaxy/rust/sleepingbag.mdl")
	self:PhysicsInitStatic(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	
end
