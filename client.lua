if Config.Use_ox_target == false then

PlayerData			= {}

Citizen.CreateThread(function()
	PlayerData = ESX.GetPlayerData()
end)

function ShowAvailableKeys()

	local available_keys_menu_entrys = {}

	ESX.TriggerServerCallback("sh59_KeySystem:GetSharedCars", function(result) 
		for _,v in pairs(result) do
			labelformated = v.amount.."x "..v.plate
			table.insert(available_keys_menu_entrys, {label = labelformated, value = "plate_menu", valdata = v.plate})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_available_keys_menu', {
			title 		= "Available Keys",
			align		= "top-right",
			elements	= available_keys_menu_entrys
		}, function(data, menu)
	
			if data.current.value == 'plate_menu' then
				OpenKeyMenu(data.current.valdata)
			end
	
		end, function(data, menu)
			menu.close()
		end)


		
	end) 
end

function ShowOwnedVehicles()

	local owned_vehicles_menu_entrys = {}

	ESX.TriggerServerCallback("sh59_KeySystem:GetOwnedVehicles", function(result) 
		for _,v in pairs(result) do
			table.insert(owned_vehicles_menu_entrys, {label = v.plate, value = "owned_plate_menu", valdata = v.plate})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_owned_vehicles_menu', {
			title 		= "Owned Vehicles",
			align		= "top-right",
			elements	= owned_vehicles_menu_entrys
		}, function(data, menu)
	
			if data.current.value == 'owned_plate_menu' then
				OpenOwnedVehMenu(data.current.valdata)
			end
	
		end, function(data, menu)
			menu.close()
		end)

	end) 
end

function OpenKeyMenu(plate)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'key_menu', {
		title 		= plate,
		align		= "top-right",
		elements	= {
			{label = "give key to next player", value = "givekey", valdata = plate}
		}
	}, function(data, menu)

		if data.current.value == 'givekey' then
			local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestPlayerDistance > 3.0 then
				ESX.ShowNotification('There\'s no player near you!')
			else	
				TriggerServerEvent("sh59_KeySystem:TransferKey", GetPlayerServerId(closestPlayer), data.current.valdata)
				ESX.UI.Menu.CloseAll()
			end
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenOwnedVehMenu(plate)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mainkey_menu', {
		title 		= plate,
		align		= "top-right",
		elements	= {
			{label = "give vehicle to next player", value = "givekey", valdata = plate}
		}
	}, function(data, menu)

		if data.current.value == 'givekey' then
			local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestPlayerDistance > 3.0 then
				ESX.ShowNotification('There\'s no player near you!')
			else
				TriggerServerEvent('sh59_KeySystem:giveawayVehicle', GetPlayerServerId(closestPlayer), data.current.valdata)
				ESX.UI.Menu.CloseAll()
			end
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenMainMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'key_main_menu', {
		title 		= "Key Menu",
		align		= "top-right",
		elements	= {
			{label = "Master Keys", value = "masterkeys"},
			{label = "Keys", value = "keys"}
		}
	}, function(data, menu)

		if data.current.value == 'keys' then
			ShowAvailableKeys()
		elseif data.current.value == 'masterkeys' then
			ShowOwnedVehicles()
		end

	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if IsControlJustReleased(0, Config.OpenMenuKey) and not IsDead then
			OpenMainMenu()
		end
	end
end)

--[[	Keyshop Functions  ]]--
function ShowOwnedVehiclesBuyKeys()

	local owned_vehicles_menu_entrys = {}

	ESX.TriggerServerCallback("sh59_KeySystem:GetOwnedVehicles", function(result) 
		for _,v in pairs(result) do
			table.insert(owned_vehicles_menu_entrys, {label = v.plate, value = "owned_plate_menu_buy_keys", valdata = v.plate})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'owned_plate_menu_buy_keys', {
			title 		= "Select vehicle",
			align		= "top-right",
			elements	= owned_vehicles_menu_entrys
		}, function(data, menu)
	
			if data.current.value == 'owned_plate_menu_buy_keys' then
				OpenOwnedVehMenuBuyKey(data.current.valdata)
			end
	
		end, function(data, menu)
			menu.close()
		end)

	end) 
end

function OpenOwnedVehMenuBuyKey(plate)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mainkey_menu', {
		title 		= plate,
		align		= "top-right",
		elements	= {
			{label = "buy key ("..Config.KeyPrice.."$)", value = "buykey", valdata = plate}
		}
	}, function(data, menu)

		if data.current.value == 'buykey' then
			TriggerServerEvent("sh59_KeySystem:BuyKey", data.current.valdata)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function ShowOwnedVehiclesChangeLocks()

	local owned_vehicles_menu_entrys = {}

	ESX.TriggerServerCallback("sh59_KeySystem:GetOwnedVehicles", function(result) 
		for _,v in pairs(result) do
			table.insert(owned_vehicles_menu_entrys, {label = v.plate, value = "owned_plate_menu_replace_lock", valdata = v.plate})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'owned_plate_menu_replace_lock', {
			title 		= "Select vehicle",
			align		= "top-right",
			elements	= owned_vehicles_menu_entrys
		}, function(data, menu)
	
			if data.current.value == 'owned_plate_menu_replace_lock' then
				OpenOwnedVehMenuChangeLock(data.current.valdata)
			end
	
		end, function(data, menu)
			menu.close()
		end)

	end) 
end

function OpenOwnedVehMenuChangeLock(plate)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mainkey_menu', {
		title 		= plate,
		align		= "top-right",
		elements	= {
			{label = "replace lock ("..Config.ReplaceLockPrice.."$)", value = "replace_lock", valdata = plate}
		}
	}, function(data, menu)

		if data.current.value == 'replace_lock' then
			TriggerServerEvent("sh59_KeySystem:ReplaceLocks", data.current.valdata)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenMainMenuLocksmith()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'key_main_menu', {
		title 		= "Locksmith",
		align		= "top-right",
		elements	= {
			{label = "Buy Keys", value = "buy"},
			{label = "Replace Lock", value = "replace"}
		}
	}, function(data, menu)

		if data.current.value == 'buy' then
			ShowOwnedVehiclesBuyKeys()
		elseif data.current.value == 'replace' then
			ShowOwnedVehiclesChangeLocks()
		end

	end, function(data, menu)
		menu.close()
	end)
end

--[[    KEYSHOP PED      ]]--
local isNearShopPed = false
local isAtShopPed = false
local isShopPedLoaded = false
local ShoppedModel = GetHashKey(Config.KeyShopPedModel)
local npc

Citizen.CreateThread(function()

    while true do

        local playerShopPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerShopPed)

        local distance = Vdist(playerCoords, Config.KeyShopPed.x, Config.KeyShopPed.y, Config.KeyShopPed.z)
        isNearShopPed = false
        isAtShopPed = false

        if distance < 20.0  then
            isNearShopPed = true
            if not isShopPedLoaded then
                RequestModel(ShoppedModel)
                while not HasModelLoaded(ShoppedModel) do
                    Wait(10)
                end

                npc = CreatePed(4, ShoppedModel, Config.KeyShopPed.x, Config.KeyShopPed.y, Config.KeyShopPed.z - 1.0, Config.KeyShopPed.hdg, false, false)
                FreezeEntityPosition(npc, true)
                SetEntityHeading(npc, Config.KeyShopPed.hdg)
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)

                isShopPedLoaded = true
            end
        end

        if isShopPedLoaded and not isNearShopPed then
            DeleteEntity(npc)
            SetModelAsNoLongerNeeded(ShoppedModel)
            isShopPedLoaded = false
        end

        if distance < 2.0 then
            isAtShopPed = true
        end
        Citizen.Wait(500)
    end

end)

Citizen.CreateThread(function()
    while true do
        if isAtShopPed then
            ESX.ShowHelpNotification('Press ~INPUT_PICKUP~ to open the ~y~Key Shop~s~.')
            if IsControlJustReleased(0, 38) then
                OpenMainMenuLocksmith()
            end
        end
        Citizen.Wait(1)
    end
end)

--[[    Blip     ]]--
Citizen.CreateThread(function()
    Citizen.Wait(1000)
        local blip = AddBlipForCoord(Config.KeyShopPed.x, Config.KeyShopPed.y, Config.KeyShopPed.z) 		-- BLIP POSITION
        SetBlipSprite(blip, Config.BlipType) 																-- BLIP TYPE
        SetBlipScale (blip, Config.BlipSize) 																-- BLIP SIZE
        SetBlipColour(blip, Config.BlipColor) 																-- BLIP COLOUR
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.BlipText) 															-- BLIP TEXT
        EndTextCommandSetBlipName(blip)
end)

end