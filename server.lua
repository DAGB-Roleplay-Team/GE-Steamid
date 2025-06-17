ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    local resourceName = GetCurrentResourceName()

    local versionTxt = LoadResourceFile(resourceName, "version.txt")
    local localVersion = versionTxt and versionTxt:match("([%d%.]+)") or nil

    if not localVersion then
        print(string.format(
            "^1[%s]^7 Impossible de lire ^3version.txt^7 pour la vérification de version.",
            resourceName
        ))
        return
    end

    local url = "https://raw.githubusercontent.com/DAGB-Roleplay-Team/GE-Steamid/main/version.txt"

    PerformHttpRequest(url, function(code, body, headers)
        if code == 200 and body then
            local remoteVersion = body:match("([%d%.]+)")
            if remoteVersion and remoteVersion ~= localVersion then
                local header = string.rep("=", 50)
                local msgBody = string.format(
                    "🚀 G-Engine Update 🚀\n" ..
                    "📦 Ressource   : ^2%s^7\n" ..
                    "🔖 Version    : ^3v%s^7 → ^2v%s^7\n" ..
                    "✨ Mettez à jour pour profiter des nouveautés !",
                    resourceName, localVersion, remoteVersion
                )
                print(
                    "^4" .. header .. "^7\n" ..
                    msgBody .. "\n" ..
                    "^4" .. header .. "^7"
                )
            end
        else
            print(string.format(
                "^1[%s]^7 Échec de la récupération de la version distante (code %d).",
                resourceName, code
            ))
        end
    end, "GET", "", { ["Content-Type"] = "text/plain" })
end)

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

    local cleanSteamId = string.sub(steamId, 7)
    TriggerClientEvent('gengine_steam_id:notify', src, "Steam ID : " .. cleanSteamId)

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    exports['ghmattimysql']:execute(
        'UPDATE users SET steam = @steam WHERE identifier = @identifier',
        {
            ['@steam'] = steamId,
            ['@identifier'] = identifier
        }
    )
end)