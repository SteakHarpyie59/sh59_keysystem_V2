if Config.Use_ox_target == true then


	-- 
	--		SHOP MENU CODE
	--

	lib.registerContext({
		id 		= "sh59_keysysten:ShopMain",
		title 	= "Keysmith",
		options = {
			{
				title	= "Buy Keys",
				menu	= "sh59_keysysten:ShopKeys",
				icon	= "fa-fas fa-key"
			},

			{
				title	= "Replace Lock",
				menu	= "sh59_keysysten:ShopLock",
				icon	= "fa-fas fa-lock"
			}
		}
	})

	function UpdateShopMenuEntrys()
		ESX.TriggerServerCallback("sh59_KeySystem:GetOwnedVehicles", function(result) 
			local options_buykeys = {}
			local options_changelocks = {}

			for _,v in pairs(result) do
				table.insert(options_buykeys, {
					title	 = v.plate,
					onSelect = function()
						TriggerServerEvent("sh59_KeySystem:BuyKey", v.plate)
					end,
					icon	 = "fa-fas fa-car"
				})

				table.insert(options_changelocks, {
					title	 = v.plate,
					onSelect = function()
						TriggerServerEvent("sh59_KeySystem:ReplaceLocks", v.plate)
					end,
					icon	 = "fa-fas fa-car"
				})
			end
			
			
			lib.registerContext({
				id 		= "sh59_keysysten:ShopKeys",
				title 	= "Buy Key ("..Config.KeyPrice .."$)",
				menu	= "sh59_keysysten:ShopMain",
				options = options_buykeys
			})

			lib.registerContext({
				id 		= "sh59_keysysten:ShopLock",
				title 	= "Replace Lock ("..Config.ReplaceLockPrice .."$)",
				menu	= "sh59_keysysten:ShopMain",
				options = options_changelocks
			})
		end) 
	end

	UpdateShopMenuEntrys()

	AddEventHandler("sh59_KeySystem:openShop_ox", function() 
		UpdateShopMenuEntrys()
		lib.showContext("sh59_keysysten:ShopMain")
	end)


	--
	--		MAIN MENU CODE
	--

	lib.registerContext({
		id 		= "sh59_keysysten:Main",
		title 	= "Key Menu",
		options = {
			{
				title	= "Master Keys",
				menu	= "sh59_keysysten:MasterKeys",
				icon	= "fa-fas fa-key"
			},

			{
				title	= "Secondary Keys",
				menu	= "sh59_keysysten:SecondaryKeys",
				icon	= "fa-fas fa-key"
			}
		}
	})

	function UpdateMenuEntrys()
		ESX.TriggerServerCallback("sh59_KeySystem:GetSharedCars", function(result) 
			local options_secondarykeys = {}

			for _,v in pairs(result) do
				table.insert(options_secondarykeys, {
					title	 = v.amount .."x "..v.plate,
					description = "Click to transfer the key to nearest player",
					onSelect = function()
						local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestPlayerDistance > 3.0 then
							ESX.ShowNotification('There\'s no player near you!')
						else	
							local payersusus = GetPlayerServerId(closestPlayer)

								local alert = lib.alertDialog({
									header = 'Are you sure?',
									content = 'Do you really want to give '..GetPlayerName(closestPlayer)..' a key for '..v.plate..'?',
									centered = true,
									cancel = true
								})

								if alert == "confirm" then
									TriggerServerEvent("sh59_KeySystem:TransferKey", payersusus, v.plate)
								end

						end
					end,
					icon	 = "fa-fas fa-car"
				})
			end

			lib.registerContext({
				id 		= "sh59_keysysten:SecondaryKeys",
				title 	= "Secondary Keys",
				menu	= "sh59_keysysten:Main",
				options = options_secondarykeys
			})
		end) 

		ESX.TriggerServerCallback("sh59_KeySystem:GetOwnedVehicles", function(result) 
			local options_masterkeys = {}

			for _,v in pairs(result) do
				table.insert(options_masterkeys, {
					title	 = v.plate,
					description = "Click to transfer VEH. OWNERSHIP to nearest player",
					onSelect = function()
						local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestPlayerDistance > 3.0 then
							ESX.ShowNotification('There\'s no player near you!')
						else
								local alert = lib.alertDialog({
									header = 'Are you sure?',
									content = 'Do you really want to transfer the vehicle ownership of '..v.plate..' to \n'..GetPlayerName(closestPlayer)..'?',
									centered = true,
									cancel = true
								})

								if alert == "confirm" then
									TriggerServerEvent("sh59_KeySystem:giveawayVehicle", GetPlayerServerId(closestPlayer), v.plate)
								end

						end
					end,
					icon	 = "fa-fas fa-car"
				})
			end

			lib.registerContext({
				id 		= "sh59_keysysten:MasterKeys",
				title 	= "Master Keys",
				menu	= "sh59_keysysten:Main",
				options = options_masterkeys
			})
		end) 
	end


	AddEventHandler("sh59_KeySystem:openMain_ox", function() 
		UpdateMenuEntrys()
		lib.showContext("sh59_keysysten:Main")
	end)

	if Config.ox.OpenWithRadial then
		lib.addRadialItem({
			id = "sh59_keysysten:radial",
			icon = "fa-fas fa-key",
			label = "Vehicle Keys",
			onSelect = function()
				TriggerEvent("sh59_KeySystem:openMain_ox")
			end
		})
	end

	if Config.ox.OpenWithKey then
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				
				if IsControlJustReleased(0, Config.OpenMenuKey) and not IsDead then
					TriggerEvent("sh59_KeySystem:openMain_ox")
				end
			end
		end)
	end


	--
	--		CREATING SHOP PEDS / BLIPS
	--

	function createBlip(BlipType, BlipColor, BlipSize, x, y, z, text)
        local blip = AddBlipForCoord(x, y, z)
    
        SetBlipSprite(blip, BlipType)
        SetBlipColour(blip, BlipColor)
        SetBlipScale(blip, BlipSize)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(text)
        EndTextCommandSetBlipName(blip)
    
        return blip
    end


	for _, v in ipairs(Config.ox.KeyShops) do
		createBlip(v.blipSettings.BlipType, v.blipSettings.BlipColor, v.blipSettings.BlipSize, v.pedSettings.coords.x, v.pedSettings.coords.y, v.pedSettings.coords.z, v.blipSettings.BlipText)

		local modelHash = GetHashKey(v.pedSettings.pedModel) -- Ändere den Model-Hash entsprechend dem gewünschten Ped
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Wait(500)
		end

		local ped = CreatePed(4, modelHash, v.pedSettings.coords.x, v.pedSettings.coords.y, v.pedSettings.coords.z,  v.pedSettings.coords.w, false, false)

		SetBlockingOfNonTemporaryEvents(ped, true)
		FreezeEntityPosition(ped, true)
		SetPedToRagdoll(ped)
		SetEntityInvincible(ped, true)

		local targetoptions = v.targetSettings
		targetoptions.onSelect = function()
			TriggerEvent("sh59_KeySystem:openShop_ox")
		end
		exports.ox_target:addLocalEntity(ped, targetoptions)
	end

end