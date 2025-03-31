AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Foundation"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Models = "models/zohart/buildings/floor_twig.mdl"

if SERVER then
    function ENT:Initialize()
        self.Entity:SetModel( "models/deployable/tool_cupboard.mdl" ) --"models/components/floor.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        local phys = self:GetPhysicsObject()

        if phys:IsValid() then
            phys:Wake()
            phys:EnableMotion( false )
        end

        constraint.Weld( self, Entity( 0 ), 0, 0, 0, true, true )
        self.Ent_Health = 150
        --self:SetMaterial("Model/effects/vol_light001")
        self:DrawShadow()
        self.SpawnTime = 0
        self.EntCount = 0
        self.DoorOpen = false
        self:SetNWInt( "health_" .. self:GetClass(), self.Ent_Health )
    end

    function ENT:Think()
        for k, v in pairs( ents.FindInSphere( self:GetPos(), 450 ) ) do
            if v.PropOwned == self.PropOwned then
                
            end
        end
    end

    function ENT:OnTakeDamage( dmg )
        local ply = dmg:GetAttacker()
        local inflictor = dmg:GetInflictor()
        --if self.PropOwned ~= ply then return end
        self.Ent_Health = self.Ent_Health - dmg:GetDamage()

        if self.Ent_Health <= 0 then
            self:Remove()
        end

        self:SetNWInt( "health_" .. self:GetClass(), self.Ent_Health )
    end

    function ENT:OnRemove()
        self:EmitSound( "zohart/building/wood_gib-4.wav" )
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
    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

    function ENT:Initialize()
    end

    function ENT:Draw()
        self:DrawModel()
    
        render.SetColorMaterial()
        render.DrawSphere(self:GetPos(), 450, 50, 50, Color(255, 0, 0, 20))
    end
end