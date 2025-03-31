BluePrint_Make("Salvaged Cleaver", {
    name = "Salvaged Cleaver",
    Class = "rust_salvagedcleaver",
    Mdl = "models/weapons/darky_m/rust/w_salvaged_Cleaver.mdl",
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
            txt = "Metal Fragments",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/salvaged_cleaver.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Salvaged Sword", {
    name = "Salvaged Sword",
    Class = "rust_salvagedsword",
    Mdl = "models/weapons/darky_m/rust/w_salvaged_sword.mdl",
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
            txt = "Metal Fragments",
            amt = 20,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/salvaged_sword.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Bone Club", {
    name = "Bone Club",
    Class = "rust_boneclub",
    Mdl = "models/weapons/darky_m/rust/w_boneclub.mdl",
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
            txt = "Bone Fragments",
            amt = 20,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("bone", 0)) or 0,
        },
    },
    img = "materials/items/weapons/bone_club.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Wooden Spear", {
    name = "Wooden Spear",
    Class = "rust_woodenspear",
    Mdl = "models/weapons/darky_m/rust/w_wooden_spear.mdl",
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
            amt = 100,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/wooden_spear.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Stone Spear", {
    name = "Stone Spear",
    Class = "rust_stonespear",
    Mdl = "models/weapons/darky_m/rust/w_stone_spear.mdl",
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
            amt = 100,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("stone", 0)) or 0,
        },
    },
    img = "materials/items/weapons/stone_spear.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Assault Rifle", {
    name = "Assault Rifle",
    Class = "rust_assaultrifle",
    Mdl = "models/weapons/darky_m/rust/w_ak47u.mdl",
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
            txt = "metal",
            amt = 100,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/assault_rifle.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful gun weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Rocket Launcher", {
    name = "Rocket Launcher",
    Class = "rust_rocketlauncher",
    Mdl = "models/weapons/darky_m/rust/w_rocketlauncher.mdl",
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
            txt = "Metal Fragments",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/salvaged_cleaver.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful gun weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("M39 Rifle", {
    name = "M39 Rifle",
    Class = "rust_m39",
    Mdl = "models/weapons/darky_m/rust/w_m39.mdl",
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
            txt = "Metal Fragments",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/m39.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful gun weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("M92 Pistol", {
    name = "M92 Pistol",
    Class = "rust_m92",
    Mdl = "models/weapons/darky_m/rust/w_m92.mdl",
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
            txt = "Metal Fragments",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/m92.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful gun weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("M249", {
    name = "M249",
    Class = "rust_m249",
    Mdl = "models/weapons/darky_m/rust/w_m249.mdl",
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
            txt = "Metal Fragments",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/m249.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful gun weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("MP5A4", {
    name = "MP5A4",
    Class = "rust_mp5",
    Mdl = "models/weapons/darky_m/rust/w_mp5.mdl",
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
            txt = "Metal Fragments",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/mp5.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful gun weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Nailgun", {
    name = "Nailgun",
    Class = "rust_nailgun",
    Mdl = "models/weapons/darky_m/rust/w_nailgun.mdl",
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
            txt = "Metal Fragments",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/nailgun.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful gun weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Python Revolver", {
    name = "Python Revolver",
    Class = "rust_python",
    Mdl = "models/weapons/darky_m/rust/w_python.mdl",
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
            txt = "Metal Fragments",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/python.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful gun weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Revolver", {
    name = "Revolver",
    Class = "rust_revolver",
    Mdl = "models/weapons/darky_m/rust/w_revolver.mdl",
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
            txt = "Metal Fragments",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/revolver.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful gun weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Semi-Automatic Pistol", {
    name = "Semi-Automatic Pistol",
    Class = "rust_sap",
    Mdl = "models/weapons/darky_m/rust/w_sap.mdl",
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
            txt = "Metal Fragments",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
        },
    },
    img = "materials/items/weapons/sap.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful gun weapon\nTime = 15 seconds to make!",
})