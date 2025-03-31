AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "tree"
ENT.Category		= ""

ENT.Spawnable			= true
ENT.AdminOnly			= false
ENT.Models = "models/props_foliage/ah_super_pine001.mdl"
if SERVER then
local tree = {
//"models/props_foliage/ah_super_large_pine002.mdl",
"models/props_foliage/ah_super_pine001.mdl",
"models/props_foliage/appletree01.mdl",
}


function ENT:Initialize()

	self.Entity:SetModel( table.Random(tree) )
		
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
			
	local phys = self:GetPhysicsObject() 
		
	if phys:IsValid() then
		
		phys:Wake()
		phys:EnableMotion(false)
	end 
	constraint.Weld( self, Entity(0), 0, 0, 0, true, true )
	//self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Ent_Health = 300	
	//self:SetMaterial("Model/effects/vol_light001")
	self:DrawShadow()
	self.SpawnTime = 0
	self.EntCount = 0
end

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	local ent = ents.Create( "zombie_tree1" )
	ent:SetPos( tr.HitPos + tr.HitNormal * 32 ) 
	ent:Spawn()
	ent:Activate()

	return ent
end
 
function ENT:Think()
end

function ENT:OnTakeDamage( dmg )
		local ply = dmg:GetAttacker()
		local inflictor = dmg:GetInflictor()
		if type(inflictor) == "Entity" then return end
		self.Ent_Health = self.Ent_Health - dmg:GetDamage()
		ply.Rnd_Amt = dmg:GetDamage()
		if tonumber(ply:GetPData("ge_easter_egg_tree",0)) >= 1000 then ply:ChatPrint("Max amount reached") return end
		ply:SetPData("ge_easter_egg_tree", ply:GetPData("ge_easter_egg_tree",0) + ply.Rnd_Amt)
		ply:SetNWInt("ge_easter_egg_tree", ply:GetPData("ge_easter_egg_tree",0))
		ply:ChatPrint(Format("Gained %s Wood, Your amount is %s", ply.Rnd_Amt,ply:GetPData("ge_easter_egg_tree",0)))
end

function ENT:Use( btn, ply )

end

function ENT:StartTouch( entity )
	return false
end

function ENT:EndTouch( entity )
	return false
end

function ENT:Touch( entity )
	return false
end

end

if CLIENT then

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT


function ENT:Initialize()
	
end

function ENT:Draw()

	self:DrawModel() 

	
end
	
end
