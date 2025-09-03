-- Author: David Brxxwn | Cxmmunity Club
-- Discord: https://discord.com/invite/EcpCFyX4DC

local QBCore = exports['qb-core']:GetCoreObject()

local activeWaypoints = {}

Citizen.CreateThread(function()
    for zoneIndex, zoneData in pairs(Config.Zones) do
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
                    lib.notify({
                        title = zoneData.notifications.title or "Notice",
                        description = zoneData.notifications.enter,
                        position = Config.Notification.position,
                        style = Config.Notification.style
                    })
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
                    exports.ox_target:addLocalEntity(npc, {
                        {
                            label = npcConfig.label or "Support HUB",
                            icon = npcConfig.icon or "fas fa-user",
                            event = "cxc_supporhub:openContextMenu",
                            args = { zoneIndex = zoneIndex, npcIndex = npcIndex }
                        }
                    }, npcConfig.distance or 2.0)
                    spawnedNpcs[npcIndex] = npc
                end
            end,
            onExit = function()
                if zoneData.notifications and zoneData.notifications.leave then
                    lib.notify({
                        title = zoneData.notifications.title or "Notice",
                        description = zoneData.notifications.leave,
                        position = Config.Notification.position,
                        style = Config.Notification.style
                    })
                end

                for npcIndex, npc in pairs(spawnedNpcs) do
                    if npc and DoesEntityExist(npc) then
                        DeleteEntity(npc)
                    end
                    spawnedNpcs[npcIndex] = nil
                end
            end,
        })
    end
end)

local function createMenuOptions(zoneIndex)
    local zoneData = Config.Zones[zoneIndex]
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
    lib.registerContext({
        id = 'main_menu',
        title = 'NPC Menu',
        options = createMenuOptions(zoneIndex),
        onBack = function() end
    })
    lib.showContext('main_menu')
end)

RegisterNetEvent('cxc_supporhub:openTeleportMenu', function(data)
    local zoneData = Config.Zones[data.zoneIndex]
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
                            labels = labels,
                            size = size,
                            overflow = overflow
                        })

                        if confirmed == 'confirm' then
                            if location.option == 1 then
                                TriggerEvent('cxc_supporhub:executeTeleport', { coords = location.location, teleportType = true })
                            elseif location.option == 2 then
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
    local zoneData = Config.Zones[data.zoneIndex]
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
                        local labels = { confirm = 'Confirm', cancel = 'Cancel' }
                        if guide.labels then
                            if type(guide.labels.confirm) == "string" then labels.confirm = guide.labels.confirm end
                            if type(guide.labels.cancel) == "string" then labels.cancel = guide.labels.cancel end
                        end

                        local header = type(guide.header) == "string" and guide.header or 'Open Guide?'
                        local content = type(guide.content) == "string" and guide.content or 'Do you really want to open this guide?'
                        local centered = type(guide.centered) == "boolean" and guide.centered or true
                        local cancel = type(guide.cancel) == "boolean" and guide.cancel or true
                        local size = type(guide.size) == "string" and guide.size or 'sm'
                        local overflow = type(guide.overflow) == "boolean" and guide.overflow or nil

                        local confirmed = lib.alertDialog({
                            header = header,
                            content = content,
                            centered = centered,
                            cancel = cancel,
                            labels = labels,
                            size = size,
                            overflow = overflow
                        })

                        if confirmed == 'confirm' then
                            if guide.option == 1 and guide.event then
                                TriggerEvent('cxc_supporhub:executeCommand', { command = guide.event })
                            elseif guide.option == 2 and guide.event then
                                TriggerEvent('cxc_supporhub:triggerExport', { export = guide.event })
                            elseif guide.option == 3 and guide.event then
                                TriggerEvent('cxc_supporhub:receiveItem', { item = guide.event })
                                elseif guide.option == 4 then
                                    lib.showContext('guide_menu')
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
        lib.notify({title = 'Teleport', description = 'Successfully teleported!', type = 'success'})
    else
        local waypointId = #activeWaypoints + 1
        activeWaypoints[waypointId] = {
            coords = vector3(data.coords.x, data.coords.y, data.coords.z),
            color = {r = 255, g = 0, b = 0}
        }
        SetNewWaypoint(data.coords.x, data.coords.y)
        lib.notify({title = 'Waypoint Set', description = 'Destination marked on the map!', type = 'inform'})
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
        lib.notify({title = 'Cancelled', description = 'You did not enter a message', type = 'error'})
    end
end)

RegisterNetEvent('cxc_supporhub:executeCommand', function(data)
    local cmd = data.command
    if type(cmd) == "string" and cmd ~= "" then
        if cmd:sub(1,1) == "/" then
            cmd = cmd:sub(2)
        end
        ExecuteCommand(cmd)
        lib.notify({title = 'Command', description = 'Command executed: /' .. cmd, type = 'inform'})
    else
        lib.notify({title = 'Command', description = 'Invalid command!', type = 'error'})
    end
end)

RegisterNetEvent('cxc_supporhub:triggerExport', function(data)
    local export = data.export:gsub(':', '')
    if exports[export] then
        local result = exports[export]()
        lib.notify({title = 'Export', description = 'Export triggered: ' .. data.export, type = 'inform'})
    else
        lib.notify({title = 'Error', description = 'Export not found!', type = 'error'})
    end
end)

RegisterNetEvent('cxc_supporhub:receiveItem', function(data)
    TriggerServerEvent('cxc_supporhub:giveItem', {
        item = data.item,
        claimableOncePerRestart = data.claimableOncePerRestart or false
    })
end)
