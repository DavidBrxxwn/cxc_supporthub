local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('oxlib:triggerWebhook', function(webhookUrl, message)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player or not message then return end

    local embedData = {
        {
            title = "**NEUE SUPPORT-ANFRAGE**",
            color = 16711680,
            fields = {
                {name = "Spieler", value = player.PlayerData.name, inline = true},
                {name = "ID", value = src, inline = true},
                {name = "Nachricht", value = message}
            },
            footer = {text = os.date('%d.%m.%Y %H:%M')}
        }
    }

    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({embeds = embedData}), {['Content-Type'] = 'application/json'})
end)

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('oxlib:triggerWebhook', function(webhookUrl, message)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player or not message then return end

    local embedData = {
        {
            title = "**NEUE SUPPORT-ANFRAGE**",
            color = 16711680,
            fields = {
                {name = "Spieler", value = player.PlayerData.name, inline = true},
                {name = "ID", value = tostring(src), inline = true},
                {name = "Nachricht", value = message}
            },
            footer = {text = os.date('%d.%m.%Y %H:%M')}
        }
    }

    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({embeds = embedData}), {['Content-Type'] = 'application/json'})
end)

RegisterNetEvent('oxlib:giveItem', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        if exports.ox_inventory:Items(item) then
            exports.ox_inventory:AddItem(src, item, 1)

            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Item erhalten',
                description = 'Du hast ein Item erhalten: ' .. item,
                type = 'success'
            })
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Fehler',
                description = 'Dieses Item existiert nicht!',
                type = 'error'
            })
        end
    end
end)
