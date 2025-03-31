print("Server")
for k, v in pairs(file.Find("gamemodes/rustorig/gamemode/files/defineables/*", "GAME")) do
    AddCSLuaFile("defineables/" .. v)
    include("defineables/" .. v)
    print("Adding defineables: " .. v)
end

for k, v in pairs(file.Find("gamemodes/rustorig/gamemode/files/shared/*", "GAME")) do
    AddCSLuaFile("shared/" .. v)
    include("shared/" .. v)
    print("Adding shared: " .. v)
end

for k, v in pairs(file.Find("gamemodes/rustorig/gamemode/files/server/*", "GAME")) do
    include("server/" .. v)
    print("Adding server: " .. v)
end

for k, v in pairs(file.Find("gamemodes/rustorig/gamemode/files/client/*", "GAME")) do
    AddCSLuaFile("client/" .. v)
    print("Adding client: " .. v)
end