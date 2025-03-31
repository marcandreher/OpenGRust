AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "storage"
ENT.Category		= ""

ENT.Spawnable			= true
ENT.AdminOnly			= false
ENT.Models =  "models/blacksnow/woodstorage.mdl" 

if SERVER then

util.AddNetworkString("GhostEngine_Storage")
util.AddNetworkString("GhostEngine_Storages")
util.AddNetworkString("GhostEngine_Storagesc")
function ENT:Initialize()

	self.Entity:SetModel( self.Models )
		
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
			
	local phys = self:GetPhysicsObject() 
		
	if phys:IsValid() then
		
		phys:Wake()
		phys:EnableMotion(false)
	end 
	constraint.Weld( self, Entity(0), 0, 0, 0, true, true )
	self.Ent_Health = 1000
	self.Ent_HealthMax = 1000
	//self:SetMaterial("Model/effects/vol_light001")
	self:DrawShadow()
	self.SpawnTime = 0
	self.EntCount = 0
	self.DoorOpen = false
	self:SetNWInt("health_"..self:GetClass(),self.Ent_Health)
	self.Storage = {}
end

--[[ function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	local ent = ents.Create( "zombie_tree1" )
	ent:SetPos( tr.HitPos + tr.HitNormal * 32 ) 
	ent:Spawn()
	ent:Activate()

	return ent
end ]]	
 
function ENT:Think()
end

function ENT:OnTakeDamage( dmg )
		local ply = dmg:GetAttacker()
		local inflictor = dmg:GetInflictor()
		if type(inflictor) == "Entity" then return end
		if self.PropOwned != ply then return end
		self.Ent_Health = self.Ent_Health - dmg:GetDamage()
		if self.Ent_Health <= 0 then self:Remove() end
		self:SetNWInt("health_"..self:GetClass(),self.Ent_Health)
end



function ENT:Use( btn, ply )
	net.Start("GhostEngine_Storage")
		net.WriteTable(self.Storage)
		net.WriteEntity(self)
	net.Send(ply)
end

local function TblAddByString(tbl,k,key)
	tbl[k] = key
end

local function TblRemoveByString(tbl,k,key)
	//if not tbl[k] == key then return end
	tbl[k] = nil
end
local i = 1
net.Receive("GhostEngine_Storages", function(len,ply)
	local ReadString = net.ReadString()
	local Self = net.ReadEntity()
	local ReadKey = net.ReadFloat()
	ply:Give(ReadString)
	TblRemoveByString(Self.Storage,ReadKey,ReadString)
	net.Start("GhostEngine_Storage")
		net.WriteTable(Self.Storage)
		net.WriteEntity(Self)
	net.Send(ply)
end)

net.Receive("GhostEngine_Storagesc", function(len,ply)
	local ReadString = net.ReadString()
	local Self = net.ReadEntity()
	local num = net.ReadFloat()
	TblAddByString(Self.Storage,num,ReadString)
	ply:StripWeapon(ReadString)
	net.Start("GhostEngine_Storage")
		net.WriteTable(Self.Storage)
		net.WriteEntity(Self)
	net.Send(ply)
end)

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

net.Receive("GhostEngine_Storage", function(len)
	if bleh == nil then bleh = 0 end
	if bleh >= CurTime() then return end
	bleh = CurTime() + 0.2
	local tbl = net.ReadTable()
	local Ent = net.ReadEntity() 
	local ply = LocalPlayer()
	if IsValid(frame) then frame:Close() end
			local frame = vgui.Create( "DFrame" )
			frame:SetTitle("Builder")
			frame:SetSize( 500, 500 )
			frame:Center()
			frame:MakePopup()

			local CatList = vgui.Create( "DCategoryList", frame )
			CatList:Dock( FILL )
			
			local plywep = ply:GetWeapons()	
		
			local Cat = CatList:Add( "Your Items" )
			for k,v in pairs(plywep) do
				if v.PrintName == nil then v.PrintName = "" end
				local button1 = Cat:Add( v.PrintName )
				button1.DoClick = function()
					net.Start("GhostEngine_Storagesc")
						net.WriteString(v:GetClass())
						net.WriteEntity(Ent)
						net.WriteFloat(k)
					net.SendToServer()
					timer.Simple(0.3, function() frame:Remove() end)
				end
			end

			local Cat = CatList:Add( "Storage" )
			for k,v in pairs(tbl) do
				local button1 = Cat:Add( v )
				button1.DoClick = function()
					net.Start("GhostEngine_Storages")
						net.WriteString(v)
						net.WriteEntity(Ent)
						net.WriteFloat(k)
					net.SendToServer()
					timer.Simple(0.3, function() frame:Remove() end)
				end
			end
 
			CatList:InvalidateLayout( true )
end)

function ENT:Draw()

	self:DrawModel() 

	
end
	
end
