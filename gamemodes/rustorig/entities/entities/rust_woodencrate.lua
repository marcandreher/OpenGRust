AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Wooden Crate"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Models = "models/environment/crates/crate.mdl"
if SERVER then
	util.AddNetworkString("gRust_GetItmz")
	util.AddNetworkString("BigBoxLott")
	function ENT:Initialize()
		self.Entity:SetModel(self.Models)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:EnableMotion(false)
		end

		local Item = {
			{
				Class = "rifle_body",
				Image = "materials/items/resources/rifle_body.png",
			}
		}

		self.RandomItem = {}
		table.insert(self.RandomItem, Item[math.random(1, #Item)])
		table.insert(self.RandomItem, Item[math.random(1, #Item)])
		table.insert(self.RandomItem, Item[math.random(1, #Item)])
		constraint.Weld(self, Entity(0), 0, 0, 0, true, true)
		self.Ent_Health = 25
		self.Ent_HealthMax = 25
		--self:SetMaterial("Model/effects/vol_light001")
		self:DrawShadow()
		self.SpawnTime = 0
		self.EntCount = 0
		self:SetNWInt("health_" .. self:GetClass(), self.Ent_Health)
	end

	function ENT:SpawnFunction(ply, tr, ClassName)
		if not tr.Hit then return end
		local SpawnPos = tr.HitPos + tr.HitNormal * 16
		local ent = ents.Create(ClassName)
		ent:SetPos(SpawnPos)
		ent:Spawn()
		ent:Activate()
		return ent
	end

	function ENT:Think()
	end

	function ENT:OnTakeDamage(dmg)
		return
		--[[local ply = dmg:GetAttacker()
		local inflictor = dmg:GetInflictor()
		--if type(inflictor) == "Entity" then return end
		--if self.PropOwned != ply then return end
		self.Ent_Health = self.Ent_Health - dmg:GetDamage()
		if self.Ent_Health <= 0 then self:Remove() end
		self:SetNWInt("health_" .. self:GetClass(), self.Ent_Health)]]
	end

	function ENT:OnRemove()
		self:EmitSound("zohart/building/wood_gib-4.wav")
	end

	function ENT:Use(btn, ply)
		net.Start("BigBoxLott")
		net.WriteTable(self.RandomItem)
		net.WriteEntity(self)
		net.Send(ply)
	end

	net.Receive("gRust_GetItmz", function(len, ply)
		local net_str = net.ReadString()
		local id = net.ReadFloat()
		local ent = net.ReadEntity()
		if ent:GetPos():Distance(ply:GetPos()) < 200 then
			table.remove(ent.RandomItem, id)
			net.Start("BigBoxLott")
			net.WriteTable(ent.RandomItem)
			net.WriteEntity(ent)
			net.Send(ply)
			ply:SetPData(net_str, ply:GetPData(net_str, 0) + 1)
		end
	end)

	function ENT:StartTouch(entity)
		return false
	end

	function ENT:EndTouch(entity)
		return false
	end

	function ENT:Touch(entity)
		return false
	end
end

if CLIENT then
	ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
	function ENT:Initialize()
	end

	function ENT:Draw()
		self:DrawModel()
	end

	local frame
	net.Receive("BigBoxLott", function()
		local tbl = net.ReadTable()
		local ent = net.ReadEntity()
		local id = 0
		local Panelnb = {}
		local pnl = {}
		if IsValid(frame) then frame:Remove() end
		frame = vgui.Create("DFrame")
		frame:SetSize(600, 550)
		frame:Center()
		frame:MakePopup()
		frame:SetTitle("Crate")
		local grid = vgui.Create("DGrid", frame)
		grid:SetPos(25, 60)
		grid:SetCols(4)
		grid:SetColWide(140)
		grid:SetRowHeight(160)
		for i = 1, 12 do
			pnl[i] = vgui.Create("DPanel")
			pnl[i]:SetSize(130, 150)
			pnl[i].Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255)) end
			grid:AddItem(pnl[i])
		end

		for k, v in pairs(tbl) do
			if k > 8 then -- stop loop after 8
				continue
			end

			local modelPanel = vgui.Create("DImageButton", pnl[k])
			modelPanel:SetSize(pnl[k]:GetWide(), pnl[k]:GetTall())
			modelPanel:SetImage(v.Image)
			modelPanel.DoClick = function()
				net.Start("gRust_GetItmz")
				net.WriteString(v.Class)
				net.WriteFloat(k)
				net.WriteEntity(ent)
				net.SendToServer()
			end
		end
	end)
end