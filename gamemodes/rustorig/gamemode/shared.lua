DeriveGamemode("base")
GM.Name = "Rust"

local meta = FindMetaTable("Player")
function meta:DeductVood(amt)
    self:RemoveInventoryWood(amt)
end
