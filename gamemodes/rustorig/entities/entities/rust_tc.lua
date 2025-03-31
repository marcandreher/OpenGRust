AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Rust Tool Cupboard"
ENT.Author = "Lolipops"
ENT.Contact = ""
ENT.Purpose = "Stores and retrieves items."
ENT.Instructions = "Use to store and retrieve items."

function ENT:SetupDataTables()
    self:NetworkVar( "Entity", 0, "Owner" )
    self:NetworkVar( "Int", 1, "MaxCapacity" )
    self:NetworkVar( "Int", 2, "CurrentCapacity" )
    self:NetworkVar( "String", 3, "Name" )
end

function ENT:Initialize()
    self:SetModel( "models/props_combine/combine_tool_chest01.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    self:SetCustomCollisionCheck( true )
    self:SetMaxCapacity( 100 )
    self:SetCurrentCapacity( 0 )
    self:SetName( "Tool Cupboard" )
    self:SetOwner( NULL )
end

function ENT:Think()
    if not self:IsValid() then return end

    if self:GetOwner() == NULL then
        self:SetOwner( self:GetWorld() )
    end

    if self:GetMaxCapacity() > self:GetCurrentCapacity() then
        self:SetColor( Color( 255, 255, 255, 255 ) )
    else
        self:SetColor( Color( 255, 0, 0, 255 ) )
    end
end

function ENT:OnTakeDamage( dmg )
    self:SetHealth( self:Health() - dmg:GetDamage() )

    if self:Health() <= 0 then
        self:Remove()
    end
end

function ENT:Use( ply )
    if not ply:IsPlayer() then return end
    if self:GetOwner() ~= ply then return end
    local menu = DermaMenu()

    for _, item in pairs( self:GetItems() ) do
        menu:AddOption( item.Name, function()
            ply:Give( item.ClassName )
        end )
    end

    menu:Open()
end

function ENT:AddItem( item )
    if self:GetMaxCapacity() <= self:GetCurrentCapacity() then return end
    self:SetCurrentCapacity( self:GetCurrentCapacity() + 1 )
    item:SetPos( self:GetPos() )
    item:SetParent( self )
end

function ENT:RemoveItem( item )
    if not item:IsValid() then return end
    self:SetCurrentCapacity( self:GetCurrentCapacity() - 1 )
    item:SetParent( NULL )
end

function ENT:GetItems()
    local items = {}

    for _, child in pairs( self:GetChildren() ) do
        if child:IsItem() then
            table.insert( items, child )
        end
    end

    return items
end