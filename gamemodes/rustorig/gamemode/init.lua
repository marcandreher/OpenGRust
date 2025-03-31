AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("files/cl_init.lua")
include("files/init.lua")
include("shared.lua")
for k, v in pairs(file.Find("materials/grustorig/*", "GAME")) do
    resource.AddFile("materials/grustorig/" .. v)
    print("Adding icons: " .. v)
end