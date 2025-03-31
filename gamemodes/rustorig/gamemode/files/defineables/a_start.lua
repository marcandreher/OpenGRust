GMRustTable = GMRustTable or {}
Crafting = Crafting or {}
player_manager.AddValidModel("RustGuy", "models/player/Spike/RustGuy.mdl")
list.Set("PlayerOptionsModel", "RustGuy", "models/player/Spike/RustGuy.mdl")
player_manager.AddValidHands("RustGuy", "models/player/spike/RustGuyArms.mdl", 0, "00000000")
Translation = function(txt) return GMRustTable[txt] or {} end
function BluePrint_Make(txt, tbl)
    local hasItem = false
    for k, v in pairs(GMRustTable) do
        if v.name == txt then hasItem = true end
    end

    if hasItem == true then return end
    GMRustTable[#GMRustTable + 1] = tbl
end

function BluePrint_Get(txt)
    local data = {}
    for k, v in pairs(GMRustTable) do
        if v.name == txt then data = v end
    end
    return data
end

function getAllBlueprints()
    local blueprints = {}

    -- Iterate through the GMRustTable to extract blueprint data
    for k, v in pairs(GMRustTable) do
        if v.name then -- Ensure it's a valid blueprint
            table.insert(blueprints, {
                name = v.name,
                class = v.Class or "N/A",
                description = v.description or "No description available",
                resources = v.resources or {},
                timers = v.timers or 0,
                model = v.Mdl or "models/error.mdl"
            })
        end
    end

    return blueprints
end


local meta = FindMetaTable("Player")

function meta:GetEnoughVood()
    return self:GetNWFloat("wood", 0)
end

function meta:HasEnoughVood(amt)
    return self:GetNWFloat("wood", 0) >= amt
end
