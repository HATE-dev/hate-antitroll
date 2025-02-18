-- bir gün allaha sormuşlar neden boynun eğri, o da demiş nerem yamukki saygılar...
local QBCore = exports['qb-core']:GetCoreObject()
local isProtected = false
local timeRemaining = 0
local protectedPlayers = {}

RegisterNetEvent('antitroll:client:syncProtectedPlayers')
AddEventHandler('antitroll:client:syncProtectedPlayers', function(players)
    protectedPlayers = players
end)

RegisterNetEvent('antitroll:client:startProtection')
AddEventHandler('antitroll:client:startProtection', function(duration)
    isProtected = true
    timeRemaining = duration * 60 -- saniyelerle oynuyoruz dayı
    
   
    SendNUIMessage({
        type = "showTimer",
        time = timeRemaining
    })
    

    Citizen.CreateThread(function()
        while timeRemaining > 0 and isProtected do
            Citizen.Wait(1000)
            timeRemaining = timeRemaining - 1
            --print('kalan süre',timeRemaining)
            SendNUIMessage({
                type = "updateTimer",
                time = timeRemaining
            })
        end
        
        if timeRemaining <= 0 then
            TriggerServerEvent('antitroll:server:protectionEnded')
            isProtected = false
            SendNUIMessage({
                type = "hideTimer"
            })
        end
    end)
end)

-- VDM koruma sistemi
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        
        if isProtected then
            
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            
            --print('girdim dayım sorun yok')
            SetEntityInvincible(ped, true)
            SetPlayerInvincible(PlayerId(), true)
        end
        
        local players = GetActivePlayers()
        for _, player in ipairs(players) do
            local playerPed = GetPlayerPed(player)
            local playerId = GetPlayerServerId(player)
            
            if protectedPlayers[playerId] then
                --print('ghostladım',playerId)
                SetEntityAlpha(playerPed, 128, false)
                local veh = GetVehiclePedIsIn(playerPed, false)
                if veh ~= 0 then
                    SetEntityAlpha(veh, 128, false)
                end
            else
                --print('resetingen şıtrayze')
                ResetEntityAlpha(playerPed)
                local veh = GetVehiclePedIsIn(playerPed, false)
                if veh ~= 0 then
                    ResetEntityAlpha(veh)
                end
            end
        end
    end
end)