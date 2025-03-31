BluePrint_Make("Hammer", {
    name = "Hammer",
    Class = "hands_hammer",
    Mdl = "models/weapons/darky_m/rust/w_hammer.mdl",
    amount = 50,
    ammo = "none",
    timers = 20,
    func = function(txt)
        print(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "Wood",
            amt = 50,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "items/tools/hammer.png",
    Where = "Construction",
    locked = false,
    Infomation = "Mallet there to upgrade stuff\nTime = 20 seconds to make!",
})

BluePrint_Make("Building Plan", {
    name = "Building Plan",
    Class = "hands_builder",
    Mdl = "models/darky_m/rust/w_buildingplan.mdl",
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
            txt = "Wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "items/tools/building_plan.png",
    Where = "Construction",
    locked = false,
    Infomation = "Building plan there to build stuff\nTime = 25 seconds to make!",
})
