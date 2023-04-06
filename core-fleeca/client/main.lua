local QBCore = exports['qb-core']:GetCoreObject()
local firsthack = false
local lockerrobbed = false
local secondhack = false
local doorlocck = false
local locker1 = false
local locker2 = false

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerServerEvent('core-fleeca:server:fleecheistready')
    else
        return
    end
end)
RegisterNetEvent('fleeca:main:timeout', function()
    local object = GetClosestObjectOfType(vector3(145.42, -1041.81, 29.64), 100.0, `v_ilev_gb_teldr`, false, false,
        false)
    local object2 = GetClosestObjectOfType(vector3(146.92, -1046.11, 29.36), 100.0, `v_ilev_gb_vauldr`, false, false,
        false)
    QBCore.Functions.Notify('the doors will close after 15min so hurry up ', 'error', 7500)
    Wait(15 * 60 * 1000)
    locker1 = false
    locker2 = false
    doorlocck = false
    secondhack = false
    lockerrobbed = false
    firsthack = false
    SetEntityHeading(object, 247.26)
    SetEntityHeading(object2, 250.69)
end)
RegisterNetEvent('fleeca:client:lockerobbed1', function()
    if not locker1 then
        TriggerEvent("core-fleeca:main:locker1")
    else
        QBCore.Functions.Notify('this locker is already robbed', 'error', 7500)
    end
end)
RegisterNetEvent('fleeca:client:lockerobbed2', function()
    if not locker2 then
        TriggerEvent("core-fleeca:main:locker2")
    else
        QBCore.Functions.Notify('this locker is already robbed', 'error', 7500)
    end
end)
RegisterNetEvent('fleeca:client:lockerobbed', function()
    if not lockerrobbed then
        TriggerEvent("Core-fleeca:client:locker")
    else
        QBCore.Functions.Notify('this door is already robbed', 'error', 7500)
    end
end)
RegisterNetEvent('fleeca:client:doorrobbed', function()
    if not doorlocck then
        TriggerEvent("core-fleeca:client:doorlocck")
    else
        QBCore.Functions.Notify('this locker is already robbed', 'error', 7500)
    end
end)
RegisterNetEvent('fleeca:client:StartHeist', function()
    if not firsthack then
        TriggerEvent('Core-fleeca:client:firsthack')
    else
        QBCore.Functions.Notify('this place is already robbed', 'error', 7500)
    end
end)
RegisterNetEvent('fleeca:client:secondhack', function()
    if not secondhack then
        TriggerEvent('Core-fleeca:client:secondhack')
    else
        QBCore.Functions.Notify('this place is already robbed wait for the cooldown', 'error', 7500)
    end
end)

RegisterNetEvent('Core-fleeca:client:firsthack', function()
    local object = GetClosestObjectOfType(vector3(145.42, -1041.81, 29.64), 5.0, `v_ilev_gb_teldr`, false, false,
        false)
    local hasitem = QBCore.Functions.HasItem('lockpick')
    local hasitem1 = QBCore.Functions.HasItem('advancedlockpick')
    local seconds = math.random(8, 12)
    local circles = math.random(4, 5)
    QBCore.Functions.TriggerCallback('core-fleeca:server:getCops', function(CoreCops)
        if CoreCops >= Config.cops then
            if hasitem or hasitem1 then
                exports['qb-dispatch']:FleecaBankRobbery(camId)
                local success = exports['qb-lock']:StartLockPickCircle(circles, seconds, success)
                if success then
                    SetEntityHeading(object, 163.8)
                    FreezeEntityPosition(object, true)
                    QBCore.Functions.Notify('go open the vault', 'succcess', 7500)
                    firsthack = true
                    createTarget()
                else
                    QBCore.Functions.Notify('you failed try again..', 'error', 7500)
                end
            else
                QBCore.Functions.Notify('you dont have the right equipement.:)', 'error', 7500)
            end
        else
            QBCore.Functions.Notify("Not Enough Police (" .. Config.cops .. " Required)", 'error', 7500)
        end
    end)
end)
RegisterNetEvent('Core-fleeca:client:secondhack', function()
    local object1 = GetClosestObjectOfType(vector3(146.92, -1046.11, 29.36), 10.0, `v_ilev_gb_vauldr`, false, false,
        false)
    local hasitem2 = QBCore.Functions.HasItem('usb_grey')
    local hasitem3 = QBCore.Functions.HasItem('green-laptop')
    if hasitem2 and hasitem3 then
        exports['qb-dispatch']:FleecaBankRobbery(camId)
        exports['qb-laptopgame']:OpenHackingGame(20, 4, 1, function(Success)
            if Success then
                QBCore.Functions.Notify('great go check the vault door', 'primary', 4500)
                Wait(7000)
                SetEntityHeading(object1, 165.47)
                FreezeEntityPosition(object1, true)
                secondhack = true
                createtarget1()
                QBCore.Functions.Notify('go rob the lockers', 'primary', 7500)
            else
                QBCore.Functions.Notify('you failed try again..', 'error', 7500)
            end
        end)
    else
        QBCore.Functions.Notify('you dont have the right equipement.:)', 'error', 7500)
    end
end)

RegisterNetEvent('Core-fleeca:client:locker', function()
    local playerPed = PlayerPedId()
    QBCore.Functions.Progressbar('robbing', 'Robbing the locker..', 60000, false, true,
        {
            -- Name | Label | Time | useWhileDead | canCancel
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'anim@gangops@facility@servers@',
            anim = 'hotwire',
            flags = 16,
        }, {}, {}, function()
            lockerrobbed = true
            createtarget2()
            TriggerServerEvent("core-fleeca:server:rewardslocker")
            ClearPedTasks(playerPed)
        end, function() -- Play When Cancel
            ClearPedTasks(playerPed)
        end)
end)
RegisterNetEvent('core-fleeca:client:doorlocck', function(data)
    local hasitem = QBCore.Functions.HasItem('lockpick')
    local hasitem1 = QBCore.Functions.HasItem('advancedlockpick')
    local seconds = math.random(8, 12)
    local circles = math.random(4, 5)
    local success = exports['qb-lock']:StartLockPickCircle(circles, seconds, success)
    if hasitem or hasitem1 then
        if success then
            TriggerServerEvent('qb-doorlock:server:updateState', 'fleecainsidedoor', false,
                false, false, true, false, false)
            doorlocck = true
            createtarget3()
        else
            QBCore.Functions.Notify('you failed to unlock the door:)', 'error', 7500)
        end
    else
        QBCore.Functions.Notify('you dont have the right equipements', 'error', 7500)
    end
end)
RegisterNetEvent('core-fleeca:main:locker1', function()
    local playerPed = PlayerPedId()
    QBCore.Functions.Progressbar('stealing', 'robbing...', 60000, false, true,
        {
            -- Name | Label | Time | useWhileDead | canCancel
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'anim@gangops@facility@servers@',
            anim = 'hotwire',
            flags = 16,
        }, {}, {}, function() -- Play When Done
            ClearPedTasks(playerPed)
            TriggerServerEvent('core-fleeca:server:rewardslocker1')
            locker1 = true
            createtarget4()
        end, function() -- Play When Cancel
            ClearPedTasks(playerPed)
        end)
end)
RegisterNetEvent('core-fleeca:main:locker2', function()
    local playerPed = PlayerPedId()
    QBCore.Functions.Progressbar('stealing', 'robbing...', 60000, false, true,
        {
            -- Name | Label | Time | useWhileDead | canCancel
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'anim@gangops@facility@servers@',
            anim = 'hotwire',
            flags = 16,
        }, {}, {}, function() -- Play When Done
            ClearPedTasks(playerPed)
            TriggerServerEvent('core-fleeca:server:rewardslocker2')
            locker2 = true
            TriggerEvent('fleeca:main:timeout')
        end, function() -- Play When Cancel
            ClearPedTasks(playerPed)
        end)
end)
function createTarget()
    exports['qb-target']:AddBoxZone('fleeca heist', vector3(151.28, -1042.73, 29.37), 1, 1, {
        name = 'fleeca heist',
        heading = 57.45,
        debugPoly = false,
        minZ = 29.37,
        maxZ = 30.37,
    }, {
        options = {
            {
                type = 'client',
                event = 'fleeca:client:secondhack',
                icon = 'fas fa-explosive',
                label = 'Hack the vault door',
            },
        },
        distance = 1.5
    })
end

function createtarget1()
    exports['qb-target']:AddBoxZone('fleeca heist', vector3(149.42, -1044.73, 29.35), 1, 1, {
        name = 'fleeca heist',
        heading = 57.45,
        debugPoly = false,
        minZ = 29.35,
        maxZ = 30.35,
    }, {
        options = {
            {
                type = 'client',
                event = 'fleeca:client:lockerobbed',
                icon = 'fas fa-lock',
                label = 'unlock the locker',
            },
        },
        distance = 1.5
    })
end

function createtarget2()
    exports['qb-target']:AddBoxZone('door robbed', vector3(148.62, -1046.26, 29.35), 1, 0.8, {
        name = 'door robbed',
        heading = 57.45,
        debugPoly = false,
        minZ = 29.35,
        maxZ = 30.35,
    }, {
        options = {
            {
                type = 'client',
                event = 'fleeca:client:doorrobbed',
                icon = 'fas fa-lock',
                label = 'Unlock the door',
            },
        },
        distance = 1.5
    })
end

function createtarget3()
    exports['qb-target']:AddBoxZone('locckere ', vector3(150.37, -1049.58, 29.35), 1, 0.8, {
        name = 'locckere',
        heading = 57.45,
        debugPoly = false,
        minZ = 29.35,
        maxZ = 30.35,
    }, {
        options = {
            {
                type = 'client',
                event = 'fleeca:client:lockerobbed1',
                icon = 'fas fa-lock',
                label = 'Unlock the locker',
            },
        },
        distance = 1.5
    })
end

function createtarget4()
    exports['qb-target']:AddBoxZone('locke ', vector3(146.83, -1048.54, 29.35), 1, 0.8, {
        name = 'locke',
        heading = 57.45,
        debugPoly = false,
        minZ = 29.35,
        maxZ = 30.35,
    }, {
        options = {
            {
                type = 'client',
                event = 'fleeca:client:lockerobbed2',
                icon = 'fas fa-lock',
                label = 'Unlock the locker',
            },
        },
        distance = 1.5
    })
end
