--  
--     SERVER CONFIG 
--

-- Discord Logging System
ServerConfig                  = {}
ServerConfig.DiscordLogging   = true -- if True, the script will log every major Action (Like Changing Vehicle Owner or Adding/Removing Keys)
ServerConfig.WebhookLink      = ""
ServerConfig.WebhookAvatar    = "https://cdn.discordapp.com/attachments/740181121794572308/1064228524786983052/log.png"







--
--      SCRIPT CODE
--

ESX.RegisterServerCallback('sh59_KeySystem:GetSharedCars', function(playerId, cb)               
    local xPlayer       = ESX.GetPlayerFromId(playerId)
    local PlayerIdent = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT * FROM sh59_keysystem WHERE user = @ident', {
            ident = PlayerIdent
        }, function(result)
            cb(result)
    end)
end)

ESX.RegisterServerCallback('sh59_KeySystem:GetOwnedVehicles', function(playerId, cb)            
    local xPlayer       = ESX.GetPlayerFromId(playerId)
    local PlayerIdent = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @ident', {
            ident = PlayerIdent
        }, function(result)
            cb(result)
    end)
end)

ESX.RegisterServerCallback('sh59_KeySystem:CheckIfShared', function(playerId, cb, plate)        
    local xPlayer       = ESX.GetPlayerFromId(playerId)
    local PlayerIdent   = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT * FROM sh59_keysystem WHERE user = @ident AND plate = @plate', {  
            ident = PlayerIdent,
            plate = plate
        }, function(result)
            for _,v in pairs(result) do
					
		    if next(result) == nil then
                	cb(false)
            	end
					
                if v.user == PlayerIdent and v.plate == plate then
                    cb(true)
                else
                    cb(false)
                end
            end
    end)
end)

AddEventHandler('sh59_KeySystem:GiveKey', function(playerId, plate)                             
    local xPlayer       = ESX.GetPlayerFromId(playerId)
    local PlayerIdent   = xPlayer.getIdentifier()
    local alreadyhas    = false
    local alreadyhasnum = 0
    local key_id        = -1

    MySQL.Async.fetchAll('SELECT * FROM sh59_keysystem WHERE user = @ident AND plate = @plate', {  
        ident = PlayerIdent,
        plate = plate
    }, function(result)
    
        for _,v in pairs(result) do
            if v.user == PlayerIdent and v.plate == plate then
                alreadyhas      = true
                alreadyhasnum   = v.amount
                key_id          = v.key_id
            else
                alreadyhas      = false
            end
        end

        if alreadyhas then
            MySQL.Async.execute("UPDATE sh59_keysystem SET amount = @amount WHERE key_id = @keyid",{	
                ident = PlayerIdent,
                plate = plate,
                amount = alreadyhasnum + 1,
                keyid  = key_id
            })
        else
            MySQL.Async.insert("INSERT INTO sh59_keysystem (user, plate, amount) VALUES (@ident, @plate, @amount)",{	
                ident = PlayerIdent,
                plate = plate,
                amount = 1
            })
        end
    
        xPlayer.showNotification("You have received a key for the vehicle with the Plate: ~y~"..plate.."~s~")
    
        -- Optional Dirscord Logging (ServerConfig.DiscordLogging)
        DiscordLog("1x Key added to Player", "Server", xPlayer.getIdentifier(), plate)
    end)   

end)

RegisterNetEvent('sh59_KeySystem:RemoveMoney')                                                  
AddEventHandler('sh59_KeySystem:RemoveMoney', function(playerId, money)
    Citizen.Trace("\n^3The trigger ^5sh59_KeySystem:RemoveMoney^3 is no longer supported due to security reasons. Please change your Code!\n^0")
end)    

AddEventHandler('sh59_KeySystem:RemoveKey', function(playerId, plate)                           
    local xPlayer       = ESX.GetPlayerFromId(playerId)
    local PlayerIdent   = xPlayer.getIdentifier()
    local alreadyhas    = false
    local alreadyhasnum = 0
    local key_id        = -1

    MySQL.Async.fetchAll('SELECT * FROM sh59_keysystem WHERE user = @ident AND plate = @plate', {  
        ident = PlayerIdent,
        plate = plate
    }, function(result)
    
        for _,v in pairs(result) do
            if v.user == PlayerIdent and v.plate == plate and v.amount > 1 then
                alreadyhas      = true
                alreadyhasnum   = v.amount
                key_id          = v.key_id
            else
                alreadyhas      = false
                key_id          = v.key_id
            end
        end

        if alreadyhas then
            MySQL.Async.execute("UPDATE sh59_keysystem SET amount = @amount WHERE key_id = @keyid",{	
                amount = alreadyhasnum - 1,
                keyid  = key_id
            })
        else
            MySQL.Async.execute("DELETE FROM sh59_keysystem WHERE key_id = @id",{
                id = key_id
            })
        end
    
        xPlayer.showNotification("You given away a key for the vehicle with the Plate: ~y~"..plate.."~s~")
    
        -- Optional Dirscord Logging (ServerConfig.DiscordLogging)
        DiscordLog("1x Key Removed From Player", "Server", xPlayer.getIdentifier(), plate)

    end)
end)

AddEventHandler('sh59_KeySystem:RemoveAllKeys', function(plate)                                 

        MySQL.Async.execute("DELETE FROM sh59_keysystem WHERE plate = @plate",{
            plate = plate
        })

        -- Optional Dirscord Logging (ServerConfig.DiscordLogging)
        DiscordLog("All Vehicle Keys Deleted", "Server", "Database", plate)
end)


-- Transfer Vehicle (Main Key)
RegisterNetEvent('sh59_KeySystem:giveawayVehicle')                                              
AddEventHandler('sh59_KeySystem:giveawayVehicle', function(target, plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local _target = target
	local tPlayer = ESX.GetPlayerFromId(_target)
	local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
			identifier = xPlayer.getIdentifier(),
			plate = plate
		})
	if result[1] ~= nil then
		MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
			owner = xPlayer.getIdentifier(),
			plate = plate,
			target = tPlayer.identifier
		}, function (rowsChanged)
			if rowsChanged ~= 0 then
				TriggerClientEvent('esx:showNotification', _source, "You gave away the master key for the vehicle with the Plate: ~y~"..plate.."~s~")
				TriggerClientEvent('esx:showNotification', _target, "You have got the master key for the vehicle with the Plate: ~y~"..plate.."~s~")
                
                -- Optional Dirscord Logging (ServerConfig.DiscordLogging)
                DiscordLog("Vehice Owner Changed", xPlayer.getIdentifier(), tPlayer.getIdentifier(), plate)
			end
		end)
	else
		TriggerClientEvent('esx:showNotification', _source, "An error has occurred. Please contact ~y~Support~s~.")
	end
end)


-- V2: New Triggers
RegisterNetEvent("sh59_KeySystem:BuyKey")
AddEventHandler("sh59_KeySystem:BuyKey", function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= Config.KeyPrice then
        xPlayer.removeMoney(Config.KeyPrice)
        TriggerEvent('sh59_KeySystem:GiveKey', source, plate)
    else 
        xPlayer.showNotification("You don't have enough money!")
    end    
end)

RegisterNetEvent("sh59_KeySystem:ReplaceLocks")
AddEventHandler("sh59_KeySystem:ReplaceLocks", function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= Config.ReplaceLockPrice then
        xPlayer.removeMoney(Config.ReplaceLockPrice)
        TriggerEvent('sh59_KeySystem:RemoveAllKeys', plate)
        xPlayer.showNotification("The locks of the vehicle with the plate "..plate.." got replaced.")
    else 
        xPlayer.showNotification("You don't have enough money!")
    end    
end)

RegisterNetEvent("sh59_KeySystem:TransferKey")
AddEventHandler("sh59_KeySystem:TransferKey", function(closestplayer, plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local souceIdent = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT amount FROM sh59_keysystem WHERE user = @ident AND plate = @plate', {  
        ident = souceIdent,
        plate = plate
    }, function(result)

        if result then
            if result[1].amount > 0 then
                TriggerEvent('sh59_KeySystem:RemoveKey', _source, plate)
                TriggerEvent('sh59_KeySystem:GiveKey', closestplayer, plate)
            else 
                xPlayer.showNotification("An error occurred while transferring the key.")
            end
        else 
            xPlayer.showNotification("An error occurred while transferring the key.")
        end
    end)
end)





-- Discord Logs

function DiscordLog(title, source, target, plate)                                               
    if ServerConfig.DiscordLogging then
        PerformHttpRequest(ServerConfig.WebhookLink, function(err, text, headers) end, 'POST', json.encode({
			embeds ={
			  {
				["title"] = title,
				["color"] = 16760904,
                ["description"] = "Source: "..source.."\nTarget: "..target.."\nPlate: "..plate,
			  }
			},
			username = "SH59 Keysystem - Log",
			avatar_url = ServerConfig.WebhookAvatar,
			attachments = {}
		  }), { ['Content-Type'] = 'application/json' })

    end
end
