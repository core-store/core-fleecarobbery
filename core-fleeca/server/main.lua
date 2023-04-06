local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('core-fleeca:server:getCops', function(source, cb)
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)


RegisterNetEvent('core-fleeca:server:fleecheistready', function()
    print('fleeca Heist made by core store is Ready')
end)
RegisterNetEvent('core-fleeca:server:rewardslocker', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(10, 20)
    Player.Functions.AddItem("markedbills", amount)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["markedbills"], "add")
end)
RegisterNetEvent('core-fleeca:server:rewardslocker1', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(7000, 15000)
    Player.Functions.AddMoney('cash', amount)
end)
RegisterNetEvent('core-fleeca:server:rewardslocker2', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(2, 5)
    Player.Functions.AddItem("diamond_necklace", amount)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["diamond_necklace"], "add")
    if math.random(1, 100) <= 5 then
        Player.Functions.AddItem("youritem", 1)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["youritem"], "add")
    end
end)
