local ESX = nil
local isTowing = false
local isPlatformUp = false
local towVehicle = nil
local platformEntity = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            if IsControlJustPressed(0, Config.TowKey) then
                if not isTowing then
                    local targetVehicle = GetVehicleInFront(vehicle)
                    if targetVehicle ~= 0 then
                        towVehicle = targetVehicle
                        isTowing = true
                        AttachVehicleToTowTruck(vehicle, targetVehicle, Config.TowDistance, Config.TowSpeed)
                    end
                else
                    isTowing = false
                    DetachVehicleFromTowTruck(towVehicle)
                    towVehicle = nil
                end
            end

            if IsControlJustPressed(0, Config.PlatformKey) then
                if not isPlatformUp then
                    isPlatformUp = true
                    platformEntity = CreateObject(GetHashKey('prop_tow_truck_01'), GetEntityCoords(vehicle), true, false, false)
                    AttachEntityToEntity(platformEntity, vehicle, 0, 0.0, -2.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                    while isPlatformUp and GetEntityHeightAboveGround(platformEntity) < Config.PlatformHeight do
                        SetEntityCoords(platformEntity, GetOffsetFromEntityInWorldCoords(platformEntity, 0.0, 0.0, Config.PlatformSpeed))
                        Citizen.Wait(0)
                    end
                else
                    isPlatformUp = false
                    while not isPlatformUp and GetEntityHeightAboveGround(platformEntity) > 0.0 do
                        SetEntityCoords(platformEntity, GetOffsetFromEntityInWorldCoords(platformEntity, 0.0, 0.0, -Config.PlatformSpeed))
                        Citizen.Wait(0)
                    end
                    DeleteEntity(platformEntity)
                    platformEntity = nil
                end
            end
        end
    end
end)

function GetVehicleInFront(vehicle)
    local coords = GetEntityCoords(vehicle)
    local forwardVector = GetEntityForwardVector(vehicle)
    local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x + forwardVector.x * Config.TowDistance, coords.y + forwardVector.y * Config.TowDistance, coords.z + forwardVector.z * Config.TowDistance, 10, vehicle, 0)
    local _, _, _, _, result = GetShapeTestResult(rayHandle)
    return result
end

function AttachVehicleToTowTruck(towTruck, targetVehicle, distance, speed)
    AttachEntityToEntity(targetVehicle, towTruck, 20, 0.0, -distance, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    SetVehicleForwardSpeed(targetVehicle, speed)
end

function DetachVehicleFromTowTruck(targetVehicle)
    DetachEntity(targetVehicle, true, true)
end

RegisterNetEvent('esx_towtruck:openBossMenu')
AddEventHandler('esx_towtruck:openBossMenu', function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu', {
        title = 'Boss Menu',
        align = 'top-left',
        elements = {
            {label = 'Hire Employee', value = 'hire_employee'},
            {label = 'Fire Employee', value = 'fire_employee'},
            {label = 'Promote Employee', value = 'promote_employee'},
            {label = 'Demote Employee', value = 'demote_employee'}
        }
    }, function(data, menu)
        if data.current.value == 'hire_employee' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'hire_employee', {
                title = 'Enter Player ID'
            }, function(data2, menu2)
                local playerId = tonumber(data2.value)
                if playerId then
                    TriggerServerEvent('esx_towtruck:hireEmployee', playerId)
                end
                menu2.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'fire_employee' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fire_employee', {
                title = 'Enter Player ID'
            }, function(data2, menu2)
                local playerId = tonumber(data2.value)
                if playerId then
                    TriggerServerEvent('esx_towtruck:fireEmployee', playerId)
                end
                menu2.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'promote_employee' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'promote_employee', {
                title = 'Enter Player ID'
            }, function(data2, menu2)
                local playerId = tonumber(data2.value)
                if playerId then
                    TriggerServerEvent('esx_towtruck:promoteEmployee', playerId)
                end
                menu2.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'demote_employee' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'demote_employee', {
                title = 'Enter Player ID'
            }, function(data2, menu2)
                local playerId = tonumber(data2.value)
                if playerId then
                    TriggerServerEvent('esx_towtruck:demoteEmployee', playerId)
                end
                menu2.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent('esx_towtruck:openClothingMenu')
AddEventHandler('esx_towtruck:openClothingMenu', function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'clothing_menu', {
        title = 'Clothing Menu',
        align = 'top-left',
        elements = {
            {label = 'Uniform 1', value = 'uniform_1'},
            {label = 'Uniform 2', value = 'uniform_2'},
            {label = 'Uniform 3', value = 'uniform_3'}
        }
    }, function(data, menu)
        if data.current.value == 'uniform_1' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadClothes', skin, {['tshirt_1'] = 15, ['tshirt_2'] = 0, ['torso_1'] = 41, ['torso_2'] = 0, ['decals_1'] = 0, ['arms'] = 15, ['pants_1'] = 25, ['shoes_1'] = 25, ['mask_1'] = 0, ['bproof_1'] = 11, ['chain_1'] = 0})
            end)
        elseif data.current.value == 'uniform_2' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadClothes', skin, {['tshirt_1'] = 15, ['tshirt_2'] = 0, ['torso_1'] = 41, ['torso_2'] = 0, ['decals_1'] = 0, ['arms'] = 15, ['pants_1'] = 25, ['shoes_1'] = 25, ['mask_1'] = 0, ['bproof_1'] = 11, ['chain_1'] = 0})
            end)
        elseif data.current.value == 'uniform_3' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadClothes', skin, {['tshirt_1'] = 15, ['tshirt_2'] = 0, ['torso_1'] = 41, ['torso_2'] = 0, ['decals_1'] = 0, ['arms'] = 15, ['pants_1'] = 25, ['shoes_1'] = 25, ['mask_1'] = 0, ['bproof_1'] = 11, ['chain_1'] = 0})
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, Config.BossMenuKey) then
            TriggerEvent('esx_towtruck:openBossMenu')
        end
        if IsControlJustPressed(0, Config.ClothingMenuKey) then
            TriggerEvent('esx_towtruck:openClothingMenu')
        end
    end
end)