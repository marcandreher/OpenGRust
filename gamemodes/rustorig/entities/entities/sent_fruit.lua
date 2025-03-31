AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "tree"
ENT.Category		= ""

ENT.Spawnable			= true
ENT.AdminOnly			= false

if SERVER then


function ENT:Initialize()

	self.Entity:SetModel( "models/props/cs_italy/orange.mdl" )
		
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
			
	local phys = self:GetPhysicsObject() 
		
	if phys:IsValid() then
		
		phys:Wake()
			
	end

	self.Ent_Health = 300	
	self:SetMaterial("Model/effects/vol_light001")
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
		
end

function ENT:Use( btn, ply )
	if ply.CoolDown == nil then ply.CoolDown = 0 end
	if ply.CoolDown <= CurTime() then
	if ply:Health() >= 100 then ply:SetHealth(100) return  end
		ply.Poison = math.random(1,3)
		if ply.Poison == 2 then
			ply:SetHealth(ply:Health() - 10)
			ply:ChatPrint("Poisoned by a fruit lost 10 hp")
		end
		ply:SetHealth(ply:Health() + 10)
		ply:ChatPrint("Eaten a fruit gained 10 hp")
	ply.CoolDown = CurTime() + 1
	end
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

surface.CreateFont( "BuilderText",
{
	font	= "Arial",
	size	= 21,
	weight	= 400
})


function ENT:Initialize()
	
end

function ENT:Draw()

	self:DrawModel() 

	
end
	
end
