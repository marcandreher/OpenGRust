BluePrint_Make("Stone Hatchet", {
    name = "Stone Hatchet",
    Class = "tfa_rustalpha_stone_hatchet",
    Mdl = "models/weapons/yurie_rustalpha/wm-stonehatchet.mdl",
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
            amt = 30,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
        {
            txt = "Stone",
            amt = 20,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("stone", 0)) or 0,
        },
    },
    img = "materials/items/weapons/salvaged_cleaver.png",
    Where = "Tools",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Rock", {
    name = "Rock",
    Class = "rust_rock",
    Mdl = "models/weapons/darky_m/rust/w_rock.mdl",
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
            txt = "Stone",
            amt = 20,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("stone", 0)) or 0,
        },
    },
    img = "materials/items/weapons/rock.png",
    Where = "Tools",
    locked = false,
    Infomation = "A rock\nTime = 15 seconds to make!",
})