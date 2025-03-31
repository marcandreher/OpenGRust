
BluePrint_Make("Syringe", {
    name = "Syringe",
    Class = "rust_syringe",
    Mdl = "models/weapons/darky_m/rust/w_syringe_v2.mdl",
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
    Where = "Medical",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})
