ESX = exports["es_extended"]:getSharedObject()

RegisterCommand('steamid', function()
    TriggerServerEvent('gengine_steam_id:getSteamId')
end, false)

RegisterNetEvent('gengine_steam_id:notify')
AddEventHandler('gengine_steam_id:notify', function(message)
    ESX.ShowNotification(message, "steam", 5000)
end)