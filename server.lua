local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_towtruck:getTowTruckData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM towtruck_data WHERE player_id = @player_id', {
        ['@player_id'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            cb(result[1])
        else
            MySQL.Async.execute('INSERT INTO towtruck_data (player_id) VALUES (@player_id)', {
                ['@player_id'] = xPlayer.identifier
            }, function()
                cb({towtruck_owned = false})
            end)
        end
    end)
end)

RegisterNetEvent('esx_towtruck:hireEmployee')
AddEventHandler('esx_towtruck:hireEmployee', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer.job.name == 'towtruck' and xPlayer.job.grade_name == 'boss' then
        if targetPlayer then
            targetPlayer.setJob('towtruck', 1)
            TriggerClientEvent('esx:showNotification', playerId, 'You have been hired as a tow truck driver.')
        else
            TriggerClientEvent('esx:showNotification', source, 'Player not found.')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'You are not the boss.')
    end
end)

RegisterNetEvent('esx_towtruck:fireEmployee')
AddEventHandler('esx_towtruck:fireEmployee', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer.job.name == 'towtruck' and xPlayer.job.grade_name == 'boss' then
        if targetPlayer then
            targetPlayer.setJob('unemployed', 0)
            TriggerClientEvent('esx:showNotification', playerId, 'You have been fired.')
        else
            TriggerClientEvent('esx:showNotification', source, 'Player not found.')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'You are not the boss.')
    end
end)

RegisterNetEvent('esx_towtruck:promoteEmployee')
AddEventHandler('esx_towtruck:promoteEmployee', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer.job.name == 'towtruck' and xPlayer.job.grade_name == 'boss' then
        if targetPlayer then
            local newGrade = targetPlayer.job.grade + 1
            targetPlayer.setJob('towtruck', newGrade)
            TriggerClientEvent('esx:showNotification', playerId, 'You have been promoted.')
        else
            TriggerClientEvent('esx:showNotification', source, 'Player not found.')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'You are not the boss.')
    end
end)

RegisterNetEvent('esx_towtruck:demoteEmployee')
AddEventHandler('esx_towtruck:demoteEmployee', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer.job.name == 'towtruck' and xPlayer.job.grade_name == 'boss' then
        if targetPlayer then
            local newGrade = targetPlayer.job.grade - 1
            if newGrade < 0 then newGrade = 0 end
            targetPlayer.setJob('towtruck', newGrade)
            TriggerClientEvent('esx:showNotification', playerId, 'You have been demoted.')
        else
            TriggerClientEvent('esx:showNotification', source, 'Player not found.')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'You are not the boss.')
    end
end)