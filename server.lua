local QBCore = exports['qb-core']:GetCoreObject()
local protectedPlayers = {}

RegisterNetEvent('QBCore:Server:OnPlayerLoaded')
AddEventHandler('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local citizenid = Player.PlayerData.citizenid
        
        MySQL.query('SELECT firstjoin FROM players WHERE citizenid = ?', {citizenid}, function(result)
            if result[1] and result[1].firstjoin then
                local firstJoinTime = result[1].firstjoin
                local currentTime = os.time()
                local timeDiff = (currentTime - firstJoinTime) / 60
                
                if timeDiff < Config.ProtectionTime then
                    local remainingTime = math.ceil(Config.ProtectionTime - timeDiff)
                    protectedPlayers[src] = true
                    TriggerClientEvent('antitroll:client:startProtection', src, remainingTime)
                    TriggerClientEvent('antitroll:client:syncProtectedPlayers', -1, protectedPlayers)
                end
            end
        end)
    end
end)

-- Koruma süresi bittiğinde
RegisterNetEvent('antitroll:server:protectionEnded')
AddEventHandler('antitroll:server:protectionEnded', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        protectedPlayers[src] = nil
        TriggerClientEvent('antitroll:client:syncProtectedPlayers', -1, protectedPlayers)

        Player.Functions.AddMoney('cash', Config.StartingMoney)
        Player.Functions.AddMoney('bank', Config.StartingBank)
        
        TriggerClientEvent('QBCore:Notify', src, 'Koruma süreniz bitti. Başlangıç paranız hesabınıza eklendi!', 'success')
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    if protectedPlayers[src] then
        protectedPlayers[src] = nil
        TriggerClientEvent('antitroll:client:syncProtectedPlayers', -1, protectedPlayers)
    end
end)