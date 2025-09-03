-- Author: David Brxxwn | Cxmmunity Club
-- Discord: https://discord.com/invite/EcpCFyX4DC

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('cxc_supporhub:triggerWebhook', function(webhookUrl, message)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player or not message then return end

    local embedConfig
    for _, zone in pairs(Config.Zones) do
        for _, menu in ipairs(zone.menus) do
            if menu.name == "webhook" and menu.webhookurl == webhookUrl then
                embedConfig = menu.embed
                break
            end
        end
        if embedConfig then break end
    end

    local function replaceVars(str)
        return str:gsub("{player}", player.PlayerData.name)
                  :gsub("{id}", tostring(src))
                  :gsub("{message}", message)
                  :gsub("{date}", os.date('%d.%m.%Y %H:%M'))
    end

    local embedData = {
        {
            title = embedConfig and replaceVars(embedConfig.title or "Support") or "Support",
            color = embedConfig and embedConfig.color or 16711680,
            fields = {},
            footer = {text = embedConfig and replaceVars(embedConfig.footer and embedConfig.footer.text or "") or os.date('%d.%m.%Y %H:%M')}
        }
    }
    if embedConfig and embedConfig.fields then
        for _, field in ipairs(embedConfig.fields) do
            table.insert(embedData[1].fields, {
                name = replaceVars(field.name),
                value = replaceVars(field.value),
                inline = field.inline
            })
        end
    else
        embedData[1].fields = {
            {name = "Player", value = player.PlayerData.name, inline = true},
            {name = "ID", value = tostring(src), inline = true},
            {name = "Message", value = message}
        }
    end

    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({embeds = embedData}), {['Content-Type'] = 'application/json'})
end)

local claimedItems = {}

RegisterNetEvent('cxc_supporhub:giveItem', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local itemData = data.item
    local claimableOnce = data.claimableOncePerRestart
    local itemName = itemData.name
    local itemLabel = itemData.label or itemName
    local itemAmount = itemData.amount or 1

    if claimableOnce then
        claimedItems[src] = claimedItems[src] or {}
        if claimedItems[src][itemName] then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Not claimable',
                description = 'You have already claimed this item!',
                type = 'error'
            })
            return
        end
        claimedItems[src][itemName] = true
    end

    if exports.ox_inventory:Items(itemName) then
        exports.ox_inventory:AddItem(src, itemName, itemAmount)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Item received',
            description = ('You received %sx %s'):format(itemAmount, itemLabel),
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'This item does not exist!',
            type = 'error'
        })
    end
end)
