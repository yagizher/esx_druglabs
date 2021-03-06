---------------------------------------
--     ESX_DRUGLABS by Dividerz      --
-- FOR SUPPORT: Arne#7777 on Discord --
---------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(library) 
    ESX = library 
end)

ESX.RegisterServerCallback('esx_druglabs:server:hasMethKey', function(source, cb)
    local sourcePlayer = ESX.GetPlayerFromId(source)

    if sourcePlayer.getInventoryItem('methkey') ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('esx_druglabs:server:hasCokeKey', function(source, cb)
    local sourcePlayer = ESX.GetPlayerFromId(source)

    if sourcePlayer.getInventoryItem('cokekey') ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('esx_druglabs:server:clearCokeStorage')
AddEventHandler('esx_druglabs:server:clearCokeStorage', function(amount)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local identifier = sourcePlayer.getIdentifier()

    if sourcePlayer.canCarryItem('cokebag', amount) then
        sourcePlayer.addInventoryItem('cokebag', amount)
        sourcePlayer.showNotification("You cleared up the storage and got ~y~" .. amount .. "~w~ bags of cocaine.")
        MySQL.Async.fetchAll('SELECT cokestorage FROM storages WHERE identifier = @identifier',  {
            ['@identifier'] = identifier
        }, function(result)
            MySQL.Async.execute('UPDATE storages SET cokestorage = cokestorage - amount WHERE identifier = @identifier', {
                ['@identifier'] = identifier,
            })
        end)
    else
        sourcePlayer.showNotification("You can't carry this amount of bags...")
    end
end)

RegisterNetEvent('esx_druglabs:server:clearMethStorage')
AddEventHandler('esx_druglabs:server:clearMethStorage', function(amount)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local identifier = sourcePlayer.getIdentifier()

    if sourcePlayer.canCarryItem('methbag', amount) then
        sourcePlayer.addInventoryItem('methbag', amount)
        sourcePlayer.showNotification("You cleared up the storage and got ~y~" .. amount .. "~w~ bags of meth.")
        MySQL.Async.fetchAll('SELECT methstorage FROM storages WHERE identifier = @identifier',  {
            ['@identifier'] = identifier
        }, function(result)
            MySQL.Async.execute('UPDATE storages SET methstorage = methstorage - amount WHERE identifier = @identifier', {
                ['@identifier'] = identifier,
            })
        end)
    else
        sourcePlayer.showNotification("You can't carry this amount of bags...")
    end
end)

RegisterNetEvent('esx_druglabs:server:addCokeStorage')
AddEventHandler('esx_druglabs:server:addCokeStorage', function(amount)
    local src = source
    local sourcePlayer = ESX.GetPlayerFromId(src)
    local identifier = sourcePlayer.getIdentifier()

    MySQL.Async.execute('UPDATE storages SET cokestorage = cokestorage + amount WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
    })
end)

RegisterNetEvent('esx_druglabs:server:addMethStorage')
AddEventHandler('esx_druglabs:server:addMethStorage', function(amount)
    local src = source
    local sourcePlayer = ESX.GetPlayerFromId(src)
    local identifier = sourcePlayer.getIdentifier()

    MySQL.Async.execute('UPDATE storages SET methstorage = methstorage + amount WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
    })
end)

ESX.RegisterServerCallback('esx_druglabs:server:checkMethStorage', function(source, cb)
    local src = source
    local sourcePlayer = ESX.GetPlayerFromId(src)
    local identifier = sourcePlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT methstorage FROM storages WHERE identifier = @identifier',  {
        ['@identifier'] = identifier
    }, function(result)
        local amount = result[1].methstorage

        cb(amount)
    end)
end)

ESX.RegisterServerCallback('esx_druglabs:server:checkCokeStorage', function(source, cb)
    local src = source
    local sourcePlayer = ESX.GetPlayerFromId(src)
    local identifier = sourcePlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT cokestorage FROM storages WHERE identifier = @identifier',  {
        ['@identifier'] = identifier
    }, function(result)
        local amount = result[1].cokestorage

        cb(amount)
    end)
end)
