ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('gengine_steam_id:getSteamId')
AddEventHandler('gengine_steam_id:getSteamId', function()
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local steamId = nil

    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, 6) == "steam:" then
            steamId = id
            break
        end
    end

    if not steamId then
        TriggerClientEvent('gengine_steam_id:notify', src, "Impossible de récupérer ton Steam ID.\nLance FiveM avec Steam ouvert !")
        return
    end

    -- Affiche dans une notif
    local cleanSteamId = string.sub(steamId, 7)
    TriggerClientEvent('gengine_steam_id:notify', src, "Steam ID " .. cleanSteamId)

    -- Enregistre en base de données
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    exports['ghmattimysql']:execute('UPDATE users SET steam = @steam WHERE identifier = @identifier', {
        ['@steam'] = steamId,
        ['@identifier'] = identifier
    })
end)