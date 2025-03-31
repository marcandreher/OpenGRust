print("Client")
for k, v in pairs(file.Find("rustorig/gamemode/files/defineables/*", "LUA")) do
    include("defineables/" .. v)
    print("Adding defineables: " .. v)
end

for k, v in pairs(file.Find("rustorig/gamemode/files/shared/*", "LUA")) do
    include("shared/" .. v)
    print("Adding shared: " .. v)
end

for k, v in pairs(file.Find("rustorig/gamemode/files/client/*", "LUA")) do
    include("client/" .. v)
    print("Adding client: " .. v)
end