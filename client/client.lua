local QBCore, ESX, QBox = nil, nil, nil
local activeWaypoints = {}
local _ = function(key, ...) return _(key, ...) end
local function FormatNotificationMessage(message)
    if Config.NotificationPosition and Config.NotificationPosition ~= "top" then
        local positionPrefix = "[" .. Config.NotificationPosition:upper() .. "] "
        return positionPrefix .. message
    end
    return message
end
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
Citizen.CreateThread(function()
    for zoneIndex, zoneData in pairs(Config.Locations) do
        if zoneData.blips then
            for _, blip in ipairs(zoneData.blips) do
                if blip and blip.coords then
                    local blipId = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
                    SetBlipSprite(blipId, blip.sprite)
                    SetBlipColour(blipId, blip.color)
                    SetBlipScale(blipId, blip.scale)
                    SetBlipAsShortRange(blipId, blip.shortRange or true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(blip.label or "Zone")
                    EndTextCommandSetBlipName(blipId)
                end
            end
        end
        local spawnedNpcs = {}
        lib.zones.sphere({
            coords = zoneData.zone.coords,
            radius = zoneData.zone.radius,
            debug = Config.Debug,
            onEnter = function()
                if zoneData.notifications and zoneData.notifications.enter then
                    if Config.Notification == 'ox' then
                        lib.notify({
                            title = zoneData.notifications.title or "Notice",
                            description = zoneData.notifications.enter,
                            position = Config.NotificationPosition or "top",
                            style = Config.NotificationStyle,
                            type = 'inform'
                        })
                    elseif Config.Notification == 'qb' then
                        if QBCore then
                            QBCore.Functions.Notify(FormatNotificationMessage(zoneData.notifications.enter), 'primary')
                        end
                    elseif Config.Notification == 'qbx' then
                        if QBox then
                            QBox.Functions.Notify(FormatNotificationMessage(zoneData.notifications.enter), 'primary')
                        end
                    elseif Config.Notification == 'gta' then
                        BeginTextCommandThefeedPost("STRING")
                        AddTextComponentSubstringPlayerName(zoneData.notifications.enter)
                        EndTextCommandThefeedPostTicker(false, true)
                    elseif Config.Notification == 'esx' then
                        if Config.Framework == 'esx' and ESX then
                            ESX.ShowNotification(FormatNotificationMessage(zoneData.notifications.enter))
                        else
                            TriggerEvent('esx:showNotification', FormatNotificationMessage(zoneData.notifications.enter))
                        end
                    end
                end
                for npcIndex, npcConfig in pairs(zoneData.npcs) do
                    RequestModel(GetHashKey(npcConfig.model))
                    while not HasModelLoaded(GetHashKey(npcConfig.model)) do
                        Wait(500)
                    end
                    local npc = CreatePed(4, GetHashKey(npcConfig.model), npcConfig.location.x, npcConfig.location.y, npcConfig.location.z - 1.0, npcConfig.location.w, false, true)
                    FreezeEntityPosition(npc, true)
                    SetEntityInvincible(npc, true)
                    SetBlockingOfNonTemporaryEvents(npc, true)
                    TaskStartScenarioInPlace(npc, npcConfig.scenario, 0, true)
                    SetModelAsNoLongerNeeded(GetHashKey(npcConfig.model))
                    if Config.Target == 'ox' then
                        exports.ox_target:addLocalEntity(npc, {
                            {
                                label = npcConfig.label or "Support HUB",
                                icon = npcConfig.icon or "fas fa-user",
                                event = "cxc_supporhub:openContextMenu",
                                args = { zoneIndex = zoneIndex, npcIndex = npcIndex }
                            }
                        }, npcConfig.distance or 2.0)
                    elseif Config.Target == 'qb' then
                        exports['qb-target']:AddTargetEntity(npc, {
                            options = {
                                {
                                    label = npcConfig.label or "Support HUB",
                                    icon = npcConfig.icon or "fas fa-user",
                                    event = "cxc_supporhub:openContextMenu",
                                    args = { zoneIndex = zoneIndex, npcIndex = npcIndex }
                                }
                            },
                            distance = npcConfig.distance or 2.0
                        })
                    elseif not Config.Target or Config.Target == false then
                        spawnedNpcs[npcIndex] = {
                            entity = npc,
                            coords = npcConfig.location,
                            distance = npcConfig.distance or 2.0,
                            label = npcConfig.label or "Support HUB",
                            zoneIndex = zoneIndex,
                            npcIndex = npcIndex
                        }
                    end
                    if Config.Target then
                        spawnedNpcs[npcIndex] = npc
                    end
                end
            end,
            onExit = function()
                if zoneData.notifications and zoneData.notifications.leave then
                    if Config.Notification == 'ox' then
                        lib.notify({
                            title = zoneData.notifications.title or "Notice",
                            description = zoneData.notifications.leave,
                            position = Config.NotificationPosition,
                            style = Config.NotificationStyle,
                            type = 'inform'
                        })
                    elseif Config.Notification == 'qb' then
                        if QBCore then
                            QBCore.Functions.Notify(FormatNotificationMessage(zoneData.notifications.leave), 'primary')
                        end
                    elseif Config.Notification == 'qbx' then
                        if QBox then
                            QBox.Functions.Notify(FormatNotificationMessage(zoneData.notifications.leave), 'primary')
                        end
                    elseif Config.Notification == 'gta' then
                        BeginTextCommandThefeedPost("STRING")
                        AddTextComponentSubstringPlayerName(zoneData.notifications.leave)
                        EndTextCommandThefeedPostTicker(false, true)
                    elseif Config.Notification == 'esx' then
                        if Config.Framework == 'esx' and ESX then
                            ESX.ShowNotification(FormatNotificationMessage(zoneData.notifications.leave))
                        else
                            TriggerEvent('esx:showNotification', FormatNotificationMessage(zoneData.notifications.leave))
                        end
                    end
                end
                for npcIndex, npcData in pairs(spawnedNpcs) do
                    local npc = npcData
                    if type(npcData) == 'table' then
                        npc = npcData.entity
                    end
                    if npc and DoesEntityExist(npc) then
                        if Config.Target == 'ox' then
                            exports.ox_target:removeLocalEntity(npc)
                        elseif Config.Target == 'qb' then
                            exports['qb-target']:RemoveTargetEntity(npc)
                        end
                        DeleteEntity(npc)
                    end
                    spawnedNpcs[npcIndex] = nil
                end
            end,
        })
    end
end)
if not Config.Target or Config.Target == false then
    local currentTextUI = nil
    local isShowingTextUI = false
    Citizen.CreateThread(function()
        while true do
            local sleep = 1000
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local nearbyNpc = nil
            for zoneIndex, zoneData in pairs(Config.Locations) do
                if zoneData.npcs then
                    for npcIndex, npcConfig in pairs(zoneData.npcs) do
                        local distance = #(playerCoords - vector3(npcConfig.location.x, npcConfig.location.y, npcConfig.location.z))
                        if distance <= (npcConfig.distance or 2.0) then
                            nearbyNpc = {
                                zoneIndex = zoneIndex,
                                npcIndex = npcIndex,
                                label = npcConfig.label or "Support HUB"
                            }
                            sleep = 0
                            break
                        end
                    end
                end
                if nearbyNpc then break end
            end
            if nearbyNpc and not isShowingTextUI then
                isShowingTextUI = true
                currentTextUI = nearbyNpc
                if Config.TextUI == 'ox' then
                    lib.showTextUI('[E] ' .. nearbyNpc.label)
                elseif Config.TextUI == 'qb' then
                    if Config.Framework == 'qb' and QBCore then
                        exports['qb-core']:DrawText('[E] ' .. nearbyNpc.label, 'left')
                    elseif Config.Framework == 'qbox' and QBox then
                        exports['qb-core']:DrawText('[E] ' .. nearbyNpc.label, 'left')
                    end
                end
            elseif not nearbyNpc and isShowingTextUI then
                isShowingTextUI = false
                currentTextUI = nil
                if Config.TextUI == 'ox' then
                    lib.hideTextUI()
                elseif Config.TextUI == 'qb' then
                    if Config.Framework == 'qb' and QBCore then
                        exports['qb-core']:HideText()
                    elseif Config.Framework == 'qbox' and QBox then
                        exports['qb-core']:HideText()
                    end
                end
            end
            if isShowingTextUI and IsControlJustPressed(0, 38) then
                TriggerEvent('cxc_supporhub:openContextMenu', {
                    zoneIndex = currentTextUI.zoneIndex,
                    npcIndex = currentTextUI.npcIndex
                })
            end
            Wait(sleep)
        end
    end)
end
local function createMenuOptions(zoneIndex)
    local zoneData = Config.Locations[zoneIndex]
    if not zoneData then
        return {}
    end
    local options = {}
    for _, menu in ipairs(zoneData.menus) do
        local name = menu.name
        if name == "webhook" and menu.webhookurl then
            options[#options+1] = {
                title = menu.title or "Call a Admin",
                description = menu.description or "Send test message",
                icon = menu.icon,
                event = 'cxc_supporhub:sendWebhook',
                args = { url = menu.webhookurl },
                metadata = menu.metadata,
                arrow = true
            }
        elseif name == "guide" and menu.guides then
            options[#options+1] = {
                title = menu.title or "Manuals & Guides",
                description = menu.description or "Learn more through guides",
                icon = menu.icon,
                event = 'cxc_supporhub:openGuideMenu',
                args = { zoneIndex = zoneIndex },
                metadata = menu.metadata,
                arrow = true
            }
        elseif name == "teleport" and menu.teleportwaypointlocations then
            options[#options+1] = {
                title = menu.title or "Teleport Options",
                description = menu.description or "Choose a destination to teleport",
                icon = menu.icon,
                event = 'cxc_supporhub:openTeleportMenu',
                args = { zoneIndex = zoneIndex },
                metadata = menu.metadata,
                arrow = true
            }
        elseif name == "command" and menu.clientcommand and menu.clientcommand ~= "" then
            options[#options+1] = {
                title = menu.title or "Execute Command",
                description = menu.description or ("Execute command: /" .. menu.clientcommand),
                icon = menu.icon,
                event = 'cxc_supporhub:executeCommand',
                args = { command = menu.clientcommand },
                metadata = menu.metadata,
                arrow = true
            }
        elseif name == "export" and menu.clientexport and menu.clientexport ~= "" then
            options[#options+1] = {
                title = menu.title or "Trigger Export",
                description = menu.description or ("Export: " .. menu.clientexport),
                icon = menu.icon,
                event = 'cxc_supporhub:triggerExport',
                args = { export = menu.clientexport },
                metadata = menu.metadata,
                arrow = true
            }
        elseif name == "item" and menu.item then
            local itemData = menu.item[1] or menu.item
            options[#options+1] = {
                title = menu.title or "Receive Item",
                description = menu.description or ("Get: " .. (itemData.label or itemData.name)),
                icon = menu.icon,
                event = 'cxc_supporhub:receiveItem',
                args = {
                    item = itemData,
                    claimableOncePerRestart = menu.claimableOncePerRestart or false
                },
                metadata = menu.metadata,
                arrow = true
            }
        end
    end
    return options
end
RegisterNetEvent('cxc_supporhub:openContextMenu', function(data)
    local zoneIndex = data.zoneIndex or (data.args and data.args.zoneIndex)
    local menuOptions = createMenuOptions(zoneIndex)
    if Config.Menu == 'ox' then
        lib.registerContext({
            id = 'main_menu',
            title = 'NPC Menu',
            options = menuOptions,
            onBack = function() end
        })
        lib.showContext('main_menu')
    elseif Config.Menu == 'qb' then
        if QBCore then
            exports['qb-menu']:openMenu(menuOptions)
        end
    end
end)
RegisterNetEvent('cxc_supporhub:openTeleportMenu', function(data)
    local zoneData = Config.Locations[data.zoneIndex]
    local teleportOptions = {}
    for _, menu in ipairs(zoneData.menus) do
    if menu.name == "teleport" and menu.teleportwaypointlocations then
            for _, location in ipairs(menu.teleportwaypointlocations) do
                teleportOptions[#teleportOptions+1] = {
                    title = location.title,
                    description = location.description,
                    icon = location.icon or "fas fa-location-arrow",
                    image = location.image,
                    metadata = location.metadata,
                    arrow = location.arrow,
                    header = location.header,
                    content = location.content,
                    size = location.size,
                    centered = location.centered,
                    overflow = location.overflow,
                    onSelect = function()
                        local labels = { confirm = 'Weiter', cancel = 'Abbrechen' }
                        if location.labels then
                            if type(location.labels.confirm) == "string" then labels.confirm = location.labels.confirm end
                            if type(location.labels.cancel) == "string" then labels.cancel = location.labels.cancel end
                        end
                        local header = type(location.header) == "string" and location.header or 'Teleport?'
                        local content = type(location.content) == "string" and location.content or 'Möchtest du wirklich teleportieren?'
                        local centered = type(location.centered) == "boolean" and location.centered or true
                        local cancel = type(location.cancel) == "boolean" and location.cancel or true
                        local size = type(location.size) == "string" and location.size or 'sm'
                        local overflow = type(location.overflow) == "boolean" and location.overflow or nil
                        local confirmed = lib.alertDialog({
                            header = header,
                            content = content,
                            centered = centered,
                            cancel = cancel,
                            size = size,
                            labels = labels,
                            overflow = overflow
                        })
                        if confirmed == 'confirm' then
                            if location.option == 1 then
                                TriggerEvent('cxc_supporhub:executeTeleport', { coords = location.location, teleportType = true })
                            else
                                TriggerEvent('cxc_supporhub:executeTeleport', { coords = location.location, teleportType = false })
                            end
                        end
                    end
                }
            end
        end
    end
    lib.registerContext({
        id = 'teleport_menu',
        title = 'Teleport Destinations',
        menu = 'main_menu',
        options = teleportOptions
    })
    lib.showContext('teleport_menu')
end)
RegisterNetEvent('cxc_supporhub:openGuideMenu', function(data)
    local zoneData = Config.Locations[data.zoneIndex]
    local guideOptions = {}
    for _, menu in ipairs(zoneData.menus) do
        if menu.name == "guide" and menu.guides then
            for _, guide in ipairs(menu.guides) do
                guideOptions[#guideOptions+1] = {
                    title = guide.title,
                    description = guide.description,
                    icon = guide.icon or "fas fa-book",
                    image = guide.image,
                    metadata = guide.metadata,
                    arrow = guide.arrow,
                    header = guide.header,
                    content = guide.content,
                    size = guide.size,
                    centered = guide.centered,
                    overflow = guide.overflow,
                    onSelect = function()
                        local labels = { confirm = 'Weiter', cancel = 'Abbrechen' }
                        if guide.labels then
                            if type(guide.labels.confirm) == "string" then labels.confirm = guide.labels.confirm end
                            if type(guide.labels.cancel) == "string" then labels.cancel = guide.labels.cancel end
                        end
                        local header = type(guide.header) == "string" and guide.header or 'Guide'
                        local content = type(guide.content) == "string" and guide.content or 'Guide content'
                        local centered = type(guide.centered) == "boolean" and guide.centered or true
                        local cancel = type(guide.cancel) == "boolean" and guide.cancel or true
                        local size = type(guide.size) == "string" and guide.size or 'md'
                        local overflow = type(guide.overflow) == "boolean" and guide.overflow or nil
                        local confirmed = lib.alertDialog({
                            header = header,
                            content = content,
                            centered = centered,
                            cancel = cancel,
                            size = size,
                            labels = labels,
                            overflow = overflow
                        })
                        if confirmed == 'confirm' then
                            if guide.option == 1 and guide.event then
                                ExecuteCommand(guide.event)
                            elseif guide.option == 2 and guide.event then
                                local export = guide.event:gsub(':', '')
                                if exports[export] then
                                    exports[export]()
                                end
                            elseif guide.option == 3 and guide.event then
                                TriggerEvent('cxc_supporhub:receiveItem', { item = guide.event })
                            elseif guide.option == 4 and guide.event then
                                TriggerEvent(guide.event)
                            end
                        end
                    end
                }
            end
        end
    end
    lib.registerContext({
        id = 'guide_menu',
        title = 'Manuals & Guides',
        menu = 'main_menu',
        options = guideOptions
    })
    lib.showContext('guide_menu')
end)
RegisterNetEvent('cxc_supporhub:executeTeleport', function(data)
    local ped = PlayerPedId()
    if data.teleportType then
        SetEntityCoords(ped, data.coords.x, data.coords.y, data.coords.z)
        SetEntityHeading(ped, data.coords.w)
        if Config.Notification == 'ox' then
            lib.notify({title = _('teleport_title'), description = _('teleport_success'), type = 'success', position = Config.NotificationPosition, style = Config.NotificationStyle})
        elseif Config.Notification == 'qb' then
            if QBCore then
                QBCore.Functions.Notify(FormatNotificationMessage('Successfully teleported!'), 'success')
            end
        elseif Config.Notification == 'qbx' then
            if QBox then
                QBox.Functions.Notify(FormatNotificationMessage('Successfully teleported!'), 'success')
            end
        elseif Config.Notification == 'gta' then
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName('Successfully teleported!')
            EndTextCommandThefeedPostTicker(false, true)
        elseif Config.Notification == 'esx' then
            if Config.Framework == 'esx' and ESX then
                ESX.ShowNotification(FormatNotificationMessage('Successfully teleported!'))
            else
                TriggerEvent('esx:showNotification', FormatNotificationMessage('Successfully teleported!'))
            end
        end
    else
        local waypointId = #activeWaypoints + 1
        activeWaypoints[waypointId] = {
            coords = vector3(data.coords.x, data.coords.y, data.coords.z),
            color = {r = 255, g = 0, b = 0}
        }
        SetNewWaypoint(data.coords.x, data.coords.y)
        if Config.Notification == 'ox' then
            lib.notify({title = _('waypoint_title'), description = _('waypoint_success'), type = 'inform', position = Config.NotificationPosition, style = Config.NotificationStyle})
        elseif Config.Notification == 'qb' then
            if QBCore then
                QBCore.Functions.Notify(FormatNotificationMessage('Destination marked on the map!'), 'primary')
            end
        elseif Config.Notification == 'qbx' then
            if QBox then
                QBox.Functions.Notify(FormatNotificationMessage('Destination marked on the map!'), 'primary')
            end
        elseif Config.Notification == 'gta' then
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName('Destination marked on the map!')
            EndTextCommandThefeedPostTicker(false, true)
        elseif Config.Notification == 'esx' then
            if Config.Framework == 'esx' and ESX then
                ESX.ShowNotification(FormatNotificationMessage('Destination marked on the map!'))
            else
                TriggerEvent('esx:showNotification', FormatNotificationMessage('Destination marked on the map!'))
            end
        end
        SetTimeout(300000, function()
            activeWaypoints[waypointId] = nil
        end)
    end
end)
RegisterNetEvent('cxc_supporhub:sendWebhook', function(data)
    local input = lib.inputDialog('Webhook Message', {
        {type = 'input', label = 'Your Message', required = true, min = 5, name = 'message'}
    })
    if input then
        local message = input[1]
        TriggerServerEvent('cxc_supporhub:triggerWebhook', data.url, message)
    else
        if Config.Notification == 'ox' then
            lib.notify({title = _('cancelled_title'), description = _('no_message_entered'), type = 'error', position = Config.NotificationPosition, style = Config.NotificationStyle})
        elseif Config.Notification == 'qb' then
            if QBCore then
                QBCore.Functions.Notify(FormatNotificationMessage('You did not enter a message'), 'error')
            end
        elseif Config.Notification == 'qbx' then
            if QBox then
                QBox.Functions.Notify(FormatNotificationMessage('You did not enter a message'), 'error')
            end
        elseif Config.Notification == 'gta' then
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName('You did not enter a message')
            EndTextCommandThefeedPostTicker(false, true)
        elseif Config.Notification == 'esx' then
            if Config.Framework == 'esx' and ESX then
                ESX.ShowNotification(FormatNotificationMessage('You did not enter a message'))
            else
                TriggerEvent('esx:showNotification', FormatNotificationMessage('You did not enter a message'))
            end
        end
    end
end)
RegisterNetEvent('cxc_supporhub:executeCommand', function(data)
    local cmd = data.command
    if type(cmd) == "string" and cmd ~= "" then
        if cmd:sub(1,1) == "/" then
            cmd = cmd:sub(2)
        end
        ExecuteCommand(cmd)
        if Config.Notification == 'ox' then
            lib.notify({title = _('command_title'), description = _('command_executed', cmd), type = 'inform', position = Config.NotificationPosition, style = Config.NotificationStyle})
        elseif Config.Notification == 'qb' then
            if QBCore then
                QBCore.Functions.Notify(FormatNotificationMessage('Command executed: /' .. cmd), 'primary')
            end
        elseif Config.Notification == 'qbx' then
            if QBox then
                QBox.Functions.Notify(FormatNotificationMessage('Command executed: /' .. cmd), 'primary')
            end
        elseif Config.Notification == 'gta' then
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName('Command executed: /' .. cmd)
            EndTextCommandThefeedPostTicker(false, true)
        elseif Config.Notification == 'esx' then
            if Config.Framework == 'esx' and ESX then
                ESX.ShowNotification(FormatNotificationMessage('Command executed: /' .. cmd))
            else
                TriggerEvent('esx:showNotification', FormatNotificationMessage('Command executed: /' .. cmd))
            end
        end
    else
        if Config.Notification == 'ox' then
            lib.notify({title = _('command_title'), description = _('invalid_command'), type = 'error', position = Config.NotificationPosition, style = Config.NotificationStyle})
        elseif Config.Notification == 'qb' then
            if QBCore then
                QBCore.Functions.Notify(FormatNotificationMessage('Invalid command!'), 'error')
            end
        elseif Config.Notification == 'qbx' then
            if QBox then
                QBox.Functions.Notify(FormatNotificationMessage('Invalid command!'), 'error')
            end
        elseif Config.Notification == 'gta' then
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName('Invalid command!')
            EndTextCommandThefeedPostTicker(false, true)
        elseif Config.Notification == 'esx' then
            if Config.Framework == 'esx' and ESX then
                ESX.ShowNotification(FormatNotificationMessage('Invalid command!'))
            else
                TriggerEvent('esx:showNotification', FormatNotificationMessage('Invalid command!'))
            end
        end
    end
end)
RegisterNetEvent('cxc_supporhub:triggerExport', function(data)
    local export = data.export:gsub(':', '')
    if exports[export] then
        local result = exports[export]()
        if Config.Notification == 'ox' then
            lib.notify({title = _('export_title'), description = _('export_triggered', data.export), type = 'inform', position = Config.NotificationPosition, style = Config.NotificationStyle})
        elseif Config.Notification == 'qb' then
            if QBCore then
                QBCore.Functions.Notify(FormatNotificationMessage('Export triggered: ' .. data.export), 'primary')
            end
        elseif Config.Notification == 'qbx' then
            if QBox then
                QBox.Functions.Notify(FormatNotificationMessage('Export triggered: ' .. data.export), 'primary')
            end
        elseif Config.Notification == 'gta' then
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName('Export triggered: ' .. data.export)
            EndTextCommandThefeedPostTicker(false, true)
        elseif Config.Notification == 'esx' then
            if Config.Framework == 'esx' and ESX then
                ESX.ShowNotification(FormatNotificationMessage('Export triggered: ' .. data.export))
            else
                TriggerEvent('esx:showNotification', FormatNotificationMessage('Export triggered: ' .. data.export))
            end
        end
    else
        if Config.Notification == 'ox' then
            lib.notify({title = _('error'), description = _('export_not_found'), type = 'error', position = Config.NotificationPosition, style = Config.NotificationStyle})
        elseif Config.Notification == 'qb' then
            if QBCore then
                QBCore.Functions.Notify(FormatNotificationMessage('Export not found!'), 'error')
            end
        elseif Config.Notification == 'qbx' then
            if QBox then
                QBox.Functions.Notify(FormatNotificationMessage('Export not found!'), 'error')
            end
        elseif Config.Notification == 'gta' then
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName('Export not found!')
            EndTextCommandThefeedPostTicker(false, true)
        elseif Config.Notification == 'esx' then
            if Config.Framework == 'esx' and ESX then
                ESX.ShowNotification(FormatNotificationMessage('Export not found!'))
            else
                TriggerEvent('esx:showNotification', FormatNotificationMessage('Export not found!'))
            end
        end
    end
end)
RegisterNetEvent('cxc_supporhub:receiveItem', function(data)
    TriggerServerEvent('cxc_supporhub:giveItem', {
        item = data.item,
        claimableOncePerRestart = data.claimableOncePerRestart or false
    })
end)
