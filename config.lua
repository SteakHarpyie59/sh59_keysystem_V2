Config                  = {}    -- To setup Discord logging, have a look in server.lua

-- Config (General)
Config.OpenMenuKey      = 57    -- In this case: 57 = F10       (Get Input ID here: https://docs.fivem.net/docs/game-references/controls/)
Config.KeyPrice         = 10 
Config.ReplaceLockPrice = 100


-- Config (ESX-Only Shop Settings) 
Config.KeyShopPedModel  = "csb_bryony" 
Config.KeyShopPed       = {x = 170.12, y = -1799.41, z = 29.32, hdg = 326.99}
Config.BlipType         = 811
Config.BlipSize         = 0.7
Config.BlipColor        = 0
Config.BlipText         = "Keysmith"



-- Config (ESX + ox_lib + ox_target)
Config.Use_ox_target    = false     -- if True, the script will use ox_lib and ox_target (https://github.com/overextended/ox_target) and IGNORES the ESX-Only config.
Config.ox = {
    OpenWithRadial = true,   -- Open the Keys Menu with ox_lib radial menu
    OpenWithKey    = true,   -- Open the Keys Menu with the Key defined in Config.OpenMenuKey

    KeyShops = {             -- This Allows you to have multiple Shops!
        {
            pedSettings = {
                coords      = vec4(170.12, -1799.41, 28.32, 326.99),
                pedModel    = "csb_bryony"
            },

            blipSettings = {
                BlipType    = 811,
                BlipSize    = 0.7,
                BlipColor   = 0,
                BlipText    = "Keysmith"
            },

            targetSettings = {
                label = "Keysmith",
                icon = "fas fa-key",
                distance = 3.0,
            }

        }
    }
}