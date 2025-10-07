local QBCore, ESX, QBox = nil, nil, nil

local _ = function(key, ...) return _(key, ...) end
local function InitializeFramework()
    if Config.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
        if Config.Debug then
            print('Framework loaded: QBCore')
        end
    elseif Config.Framework == 'qbox' then
        QBox = exports.qbx_core
        if Config.Debug then
            print('Framework loaded: QBox')
        end
    elseif Config.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        if Config.Debug then
            print('Framework loaded: ESX')
        end
    else
        if Config.Debug then
            print('Framework error: ' .. Config.Framework)
        end
    end
end

Citizen.CreateThread(function()
    InitializeFramework()
end)
local function GetPlayerData(src)
    if Config.Framework == 'qb' and QBCore then
        return QBCore.Functions.GetPlayer(src)
    elseif Config.Framework == 'qbox' and QBox then
        return QBox:GetPlayer(src)
    elseif Config.Framework == 'esx' and ESX then
        return ESX.GetPlayerFromId(src)
    end
    return nil
end

RegisterNetEvent('cxc_supporhub:triggerWebhook', function(webhookUrl, message)
    local src = source
    local player = GetPlayerData(src)
    if not player or not message then return end

    local embedConfig
    for _, zone in pairs(Config.Locations) do
        for _, menu in ipairs(zone.menus) do
            if menu.name == "webhook" and menu.webhookurl == webhookUrl then
                embedConfig = menu.embed
                break
            end
        end
        if embedConfig then break end
    end

    local function replaceVars(str)
        local playerName = ""
        if Config.Framework == 'qb' or Config.Framework == 'qbox' then
            playerName = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
        elseif Config.Framework == 'esx' then
            playerName = player.getName()
        end
        
        return str:gsub("{player}", playerName)
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
    local Player = GetPlayerData(src)
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
                title = _('not_claimable'),
                description = _('already_claimed'),
                type = 'error'
            })
            return
        end
        claimedItems[src][itemName] = true
    end

    local success = false
    if Config.Inventory == 'ox' then
        if exports.ox_inventory:Items(itemName) then
            exports.ox_inventory:AddItem(src, itemName, itemAmount)
            success = true
        end
    elseif Config.Inventory == 'qb' then
        if Config.Framework == 'qb' or Config.Framework == 'qbox' then
            if Player and Player.Functions then
                success = Player.Functions.AddItem(itemName, itemAmount)
                if success then
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'add')
                end
            end
        end
    end
    
    if success then
        if Config.Notification == 'ox' then
            TriggerClientEvent('ox_lib:notify', src, {
                title = _('item_received'),
                description = _('received_items', itemAmount, itemLabel),
                type = 'success'
            })
        elseif Config.Notification == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, _('received_items', itemAmount, itemLabel), 'success')
        end
    else
        if Config.Notification == 'ox' then
            TriggerClientEvent('ox_lib:notify', src, {
                title = _('error'),
                description = _('item_not_exist'),
                type = 'error'
            })
        elseif Config.Notification == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, _('item_not_exist'), 'error')
        end
    end
end)
