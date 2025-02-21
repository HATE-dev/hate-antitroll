local QBCore = exports['qb-core']:GetCoreObject()
local protectedPlayers = {}

MySQL.ready(function()
    MySQL.query("SHOW COLUMNS FROM players LIKE 'firstjoin'", function(result)
        if result[1] == nil then
            MySQL.query("ALTER TABLE players ADD COLUMN firstjoin INT(11) NULL")
        end
    end)
end)

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
            else
                -- İlk kez giriş yapan oyuncu için şuanki zamanı kaydet
                MySQL.update('UPDATE players SET firstjoin = ? WHERE citizenid = ?', {os.time(), citizenid})
                protectedPlayers[src] = true
                TriggerClientEvent('antitroll:client:startProtection', src, Config.ProtectionTime)
                TriggerClientEvent('antitroll:client:syncProtectedPlayers', -1, protectedPlayers)
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
        
        TriggerClientEvent('QBCore:Notify', src, 'Your protection time has ended. Starting money has been added to your account!', 'success')
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    if protectedPlayers[src] then
        protectedPlayers[src] = nil
        TriggerClientEvent('antitroll:client:syncProtectedPlayers', -1, protectedPlayers)
    end
end)

QBCore.Commands.Add('removeprotection', 'End player protection time', {{name = 'id', help = 'Player ID'}}, true, function(source, args)
    local src = source
    local admin = QBCore.Functions.GetPlayer(src)
    
    -- if not admin.PlayerData.permission == "admin" then
    --     TriggerClientEvent('QBCore:Notify', src, 'Bu komutu kullanmak için yetkiniz yok!', 'error')
    --     return
    -- end

    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('QBCore:Notify', src, 'Please enter a valid ID!', 'error')
        return
    end

    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, 'Player not found!', 'error')
        return
    end

    local newTime = os.time() - (Config.ProtectionTime * 60)
    MySQL.update('UPDATE players SET firstjoin = ? WHERE citizenid = ?', {newTime, targetPlayer.PlayerData.citizenid})
    
    if protectedPlayers[targetId] then
        protectedPlayers[targetId] = nil
        TriggerClientEvent('antitroll:client:syncProtectedPlayers', -1, protectedPlayers)
        TriggerClientEvent('antitroll:client:stopProtection', targetId)
    end

    TriggerClientEvent('QBCore:Notify', src, 'Protection removed for player ID: ' .. targetId, 'success')
    TriggerClientEvent('QBCore:Notify', targetId, 'Your protection has been removed by an administrator!', 'info')
end, 'god')