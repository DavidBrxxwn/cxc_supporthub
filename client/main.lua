local QBCore = exports['qb-core']:GetCoreObject()
local activeMarkers = {}

Citizen.CreateThread(function()
    for npcIndex, npcConfig in ipairs(Config.npcCoords) do
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

        exports['qb-target']:AddTargetEntity(npc, {
            options = {
                {
                    event = "oxlib:openContextMenu",
                    icon = "fas fa-user",
                    label = "Support HUB",
                    npcIndex = npcIndex,
                }
            },
            distance = npcConfig.distance
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for id, marker in pairs(activeMarkers) do
            if #(playerCoords - marker.coords) < 50.0 then
                lib.drawMarker({
                    type = 1,
                    x = marker.coords.x,
                    y = marker.coords.y,
                    z = marker.coords.z - 1.0,
                    scale = {2.0, 2.0, 1.0},
                    color = {r = marker.color.r, g = marker.color.g, b = marker.color.b, a = 100},
                    direction = {0.0, 0.0, 0.0},
                    rotate = false,
                    outline = true,e
                    bobUpAndDown = false,
                    faceCam = false,
                })
            end
        end
    end
end)

local function createMenuOptions(npcConfig)
    local menuOrder = {}
    for name, order in pairs(npcConfig.menuorder) do
        menuOrder[order] = name
    end

    local options = {}
    for i = 1, #menuOrder do
        local menuType = menuOrder[i]
        if npcConfig[menuType] then
            if menuType == 'eventmenu' and npcConfig.clientevent then
                options[#options+1] = {
                    title = "Start Tutorial",
                    description = "Start the tutorial",
                    icon = npcConfig.eventmenuicon,
                    event = npcConfig.clientevent,
                    arrow = true
                }
            elseif menuType == 'browsermenu' and npcConfig.browserurl then
                options[#options+1] = {
                    title = "Open Website",
                    description = "Open: " .. npcConfig.browserurl,
                    icon = npcConfig.browsermenuicon,
                    event = 'oxlib:openBrowser',
                    args = {url = npcConfig.browserurl},
                    arrow = true
                }
            elseif menuType == 'webhookmenu' and npcConfig.webhookurl then
                options[#options+1] = {
                    title = "Call a Admin",
                    description = "Send test message",
                    icon = npcConfig.webhookmenuicon,
                    event = 'oxlib:sendWebhook',
                    args = {url = npcConfig.webhookurl},
                    arrow = true
                }
            elseif menuType == 'guidemenu' and npcConfig.guides then
                options[#options+1] = {
                    title = "Manuals & Guides",
                    description = "Learn more through guides",
                    icon = npcConfig.guidemenuicon,
                    event = 'oxlib:openGuideMenu',
                    args = {npcIndex = npcConfig.npcIndex},
                    arrow = true
                }
            elseif menuType == 'teleportmarkermenu' and npcConfig.teleportmarkerlocations then
                options[#options+1] = {
                    title = "Teleport Options",
                    description = "Choose a destination to teleport",
                    icon = npcConfig.teleportmenuicon,
                    event = 'oxlib:openTeleportMenu',
                    args = {npcIndex = npcConfig.npcIndex},
                    arrow = true
                }
            elseif menuType == 'commandmenu' and npcConfig.clientcommand then
                options[#options+1] = {
                    title = "Execute Command",
                    description = "Execute command: /" .. npcConfig.clientcommand,
                    icon = npcConfig.commandmenuicon,
                    event = 'oxlib:executeCommand',
                    args = {command = npcConfig.clientcommand},
                    arrow = true
                }
            elseif menuType == 'exportmenu' and npcConfig.clientexport then
                options[#options+1] = {
                    title = "Trigger Export",
                    description = "Export: " .. npcConfig.clientexport,
                    icon = npcConfig.exportmenuicon,
                    event = 'oxlib:triggerExport',
                    args = {export = npcConfig.clientexport},
                    arrow = true
                }
            elseif menuType == 'itemmenu' and npcConfig.item then
                options[#options+1] = {
                    title = "Receive Item",
                    description = "Get: " .. npcConfig.item,
                    icon = npcConfig.itemmenuicon,
                    event = 'oxlib:receiveItem',
                    args = {item = npcConfig.item},
                    arrow = true
                }
            elseif menuType == 'extramenu' and npcConfig.extras then
                options[#options+1] = {
                    title = "Extras",
                    description = "Additional features",
                    icon = npcConfig.extramenuicon,
                    event = 'oxlib:openExtraMenu',
                    args = {npcIndex = npcConfig.npcIndex},
                    arrow = true
                }
            end
        end
    end
    return options
end

local function createExtraOptions(extraConfig)
    local options = {}
    
    if extraConfig.commandmenu and extraConfig.clientcommand then
        options[#options+1] = {
            title = "Execute Command",
            description = "Execute command: /" .. extraConfig.clientcommand,
            icon = extraConfig.commandmenuicon or "fas fa-terminal",
            event = 'oxlib:executeCommand',
            args = {command = extraConfig.clientcommand},
            arrow = true
        }
    end
    
    if extraConfig.eventmenu and extraConfig.clientevent then
        options[#options+1] = {
            title = "Trigger Event",
            description = "Trigger Event: " .. extraConfig.clientevent,
            icon = extraConfig.eventmenuicon or "fas fa-bolt",
            event = extraConfig.clientevent,
            arrow = true
        }
    end
    
    if extraConfig.browsermenu and extraConfig.browserurl then
        options[#options+1] = {
            title = "Open Website",
            description = "Open: " .. extraConfig.browserurl,
            icon = extraConfig.browsermenuicon or "fas fa-globe",
            event = 'oxlib:openBrowser',
            args = {url = extraConfig.browserurl},
            arrow = true
        }
    end
    
    if extraConfig.itemmenu and extraConfig.item then
        options[#options+1] = {
            title = "Receive Item",
            description = "Get: " .. extraConfig.item,
            icon = extraConfig.itemmenuicon or "fas fa-gift",
            event = 'oxlib:receiveItem',
            args = {item = extraConfig.item},
            arrow = true
        }
    end
    
    if extraConfig.exportmenu and extraConfig.clientexport then
        options[#options+1] = {
            title = "Trigger Export",
            description = "Export: " .. extraConfig.clientexport,
            icon = extraConfig.exportmenuicon or "fas fa-code",
            event = 'oxlib:triggerExport',
            args = {export = extraConfig.clientexport},
            arrow = true
        }
    end
    
    if extraConfig.guidemenu and extraConfig.guides then
        options[#options+1] = {
            title = "Open Guide",
            description = "Read the guide",
            icon = extraConfig.guidemenuicon or "fas fa-book",
            event = 'oxlib:openGuideMenu',
            args = {guides = extraConfig.guides},
            arrow = true
        }
    end
    
    if extraConfig.teleportmarkermenu and extraConfig.teleportmarkerlocations then
        options[#options+1] = {
            title = "Teleport",
            description = "Choose a destination",
            icon = extraConfig.teleportmenuicon or "fas fa-map-marker-alt",
            event = 'oxlib:openTeleportMenu',
            args = {locations = extraConfig.teleportmarkerlocations},
            arrow = true
        }
    end

    return options
end

RegisterNetEvent('oxlib:openContextMenu', function(data)
    local npcConfig = Config.npcCoords[data.npcIndex]
    npcConfig.npcIndex = data.npcIndex

    lib.registerContext({
        id = 'main_menu',
        title = 'NPC Menu',
        options = createMenuOptions(npcConfig),
        onBack = function() end
    })

    lib.showContext('main_menu')
end)

RegisterNetEvent('oxlib:openExtraMenu', function(args)
    local npcConfig = Config.npcCoords[args.npcIndex]
    local extraOptions = {}

    for extraIndex, extra in ipairs(npcConfig.extras) do
        extraOptions[#extraOptions+1] = {
            title = extra.title,
            description = extra.description,
            image = extra.image,
            menu = 'extra_submenu_' .. extraIndex,
            arrow = true
        }

        lib.registerContext({
            id = 'extra_submenu_' .. extraIndex,
            title = extra.title,
            menu = 'main_menu',
            options = createExtraOptions(extra),
            onBack = function() end
        })
    end

    lib.registerContext({
        id = 'extra_main_menu',
        title = 'Extras',
        menu = 'main_menu',
        options = extraOptions
    })

    lib.showContext('extra_main_menu')
end)

RegisterNetEvent('oxlib:openTeleportMenu', function(args)
    local npcConfig = Config.npcCoords[args.npcIndex]
    local teleportOptions = {}

    for _, location in ipairs(npcConfig.teleportmarkerlocations) do
        teleportOptions[#teleportOptions+1] = {
            title = location.title,
            description = location.description,
            icon = "fas fa-location-arrow",
            event = 'oxlib:executeTeleport',
            args = {
                coords = location.location,
                teleportType = npcConfig.teleportmarker
            },
            image = location.image
        }
    end

    lib.registerContext({
        id = 'teleport_menu',
        title = 'Teleport Destinations',
        menu = 'main_menu',
        options = teleportOptions
    })

    lib.showContext('teleport_menu')
end)

RegisterNetEvent('oxlib:openGuideMenu', function(args)
    local npcConfig = Config.npcCoords[args.npcIndex]
    local guideOptions = {}

    for _, guide in ipairs(npcConfig.guides) do
        guideOptions[#guideOptions+1] = {
            title = guide.title,
            description = guide.description,
            icon = "fas fa-book",
            image = guide.image,
            onSelect = function()
                lib.alertDialog({
                    header = 'Open Guide?',
                    content = 'Do you really want to open this guide?',
                    centered = true,
                    cancel = true,
                    labels = {
                        confirm = 'Confirm',
                        cancel = 'Cancel'
                    },
                    size = 'sm'
                }, function(confirmed)
                    if confirmed then
                        if guide.url then
                            TriggerEvent('oxlib:openBrowser', {url = guide.url})
                        elseif guide.event then
                            TriggerEvent(guide.event)
                        end
                    end
                end)
            end
        }
    end

    lib.registerContext({
        id = 'guide_menu',
        title = 'Manuals & Guides',
        menu = 'main_menu',
        options = guideOptions
    })

    lib.showContext('guide_menu')
end)

RegisterNetEvent('oxlib:executeTeleport', function(data)
    local ped = PlayerPedId()
    if data.teleportType then
        SetEntityCoords(ped, data.coords.x, data.coords.y, data.coords.z)
        SetEntityHeading(ped, data.coords.w)
        lib.notify({title = 'Teleport', description = 'Successfully teleported!', type = 'success'})
    else
        local markerId = #activeMarkers + 1
        activeMarkers[markerId] = {
            coords = vector3(data.coords.x, data.coords.y, data.coords.z),
            color = {r = 255, g = 0, b = 0}
        }
        SetNewWaypoint(data.coords.x, data.coords.y)
        lib.notify({title = 'Marker Set', description = 'Destination marked on the map!', type = 'inform'})
        SetTimeout(300000, function()
            activeMarkers[markerId] = nil
        end)
    end
end)

RegisterNetEvent('oxlib:sendWebhook', function(data)
    local input = lib.inputDialog('Webhook Message', {
        {type = 'input', label = 'Your Message', required = true, min = 5, name = 'message'}
    })

    if input then
        local message = input[1]
        TriggerServerEvent('oxlib:triggerWebhook', data.url, message)
    else
        lib.notify({title = 'Cancelled', description = 'You did not enter a message', type = 'error'})
    end
end)

RegisterNetEvent('oxlib:openBrowser', function(data)
    SendNUIMessage({
        action = 'openBrowser',
        url = data.url
    })
end)

RegisterNetEvent('oxlib:executeCommand', function(data)
    ExecuteCommand(data.command)
    lib.notify({title = 'Command', description = 'Command executed: /' .. data.command, type = 'inform'})
end)

RegisterNetEvent('oxlib:triggerExport', function(data)
    local export = data.export:gsub(':', '')
    if exports[export] then
        local result = exports[export]()
        lib.notify({title = 'Export', description = 'Export triggered: ' .. data.export, type = 'inform'})
    else
        lib.notify({title = 'Error', description = 'Export not found!', type = 'error'})
    end
end)

RegisterNetEvent('oxlib:receiveItem', function(data)
    TriggerServerEvent('oxlib:giveItem', data.item)
end)
