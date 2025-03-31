BluePrint_Make("Sleeping Bag", {
    name = "Sleeping Bag",
    Class = "sleeper_bag",
    Mdl = "models/galaxy/rust/sleepingbag.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "Cloth",
            amt = 30,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("cloth", 0)) or 0,
        },
    },
    need2 = {},
    img = "materials/items/weapons/salvaged_cleaver.png",
    Where = "Resources",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})