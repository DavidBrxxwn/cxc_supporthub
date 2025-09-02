-- Menu Module
-- Handles menu creation and context management

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
                    event = 'cxc_supporthub:openBrowser',
                    args = {url = npcConfig.browserurl},
                    arrow = true
                }
            elseif menuType == 'webhookmenu' and npcConfig.webhookurl then
                options[#options+1] = {
                    title = "Call a Admin",
                    description = "Send test message",
                    icon = npcConfig.webhookmenuicon,
                    event = 'cxc_supporthub:sendWebhook',
                    args = {url = npcConfig.webhookurl},
                    arrow = true
                }
            elseif menuType == 'guidemenu' and npcConfig.guides then
                options[#options+1] = {
                    title = "Manuals & Guides",
                    description = "Learn more through guides",
                    icon = npcConfig.guidemenuicon,
                    event = 'cxc_supporthub:openGuideMenu',
                    args = {npcIndex = npcConfig.npcIndex},
                    arrow = true
                }
            elseif menuType == 'teleportmarkermenu' and npcConfig.teleportmarkerlocations then
                options[#options+1] = {
                    title = "Teleport Options",
                    description = "Choose a destination to teleport",
                    icon = npcConfig.teleportmenuicon,
                    event = 'cxc_supporthub:openTeleportMenu',
                    args = {npcIndex = npcConfig.npcIndex},
                    arrow = true
                }
            elseif menuType == 'commandmenu' and npcConfig.clientcommand then
                options[#options+1] = {
                    title = "Execute Command",
                    description = "Execute command: /" .. npcConfig.clientcommand,
                    icon = npcConfig.commandmenuicon,
                    event = 'cxc_supporthub:executeCommand',
                    args = {command = npcConfig.clientcommand},
                    arrow = true
                }
            elseif menuType == 'exportmenu' and npcConfig.clientexport then
                options[#options+1] = {
                    title = "Trigger Export",
                    description = "Export: " .. npcConfig.clientexport,
                    icon = npcConfig.exportmenuicon,
                    event = 'cxc_supporthub:triggerExport',
                    args = {export = npcConfig.clientexport},
                    arrow = true
                }
            elseif menuType == 'itemmenu' and npcConfig.item then
                options[#options+1] = {
                    title = "Receive Item",
                    description = "Get: " .. npcConfig.item,
                    icon = npcConfig.itemmenuicon,
                    event = 'cxc_supporthub:receiveItem',
                    args = {item = npcConfig.item},
                    arrow = true
                }
            elseif menuType == 'extramenu' and npcConfig.extras then
                options[#options+1] = {
                    title = "Extras",
                    description = "Additional features",
                    icon = npcConfig.extramenuicon,
                    event = 'cxc_supporthub:openExtraMenu',
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
            event = 'cxc_supporthub:executeCommand',
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
            event = 'cxc_supporthub:openBrowser',
            args = {url = extraConfig.browserurl},
            arrow = true
        }
    end
    
    if extraConfig.itemmenu and extraConfig.item then
        options[#options+1] = {
            title = "Receive Item",
            description = "Get: " .. extraConfig.item,
            icon = extraConfig.itemmenuicon or "fas fa-gift",
            event = 'cxc_supporthub:receiveItem',
            args = {item = extraConfig.item},
            arrow = true
        }
    end
    
    if extraConfig.exportmenu and extraConfig.clientexport then
        options[#options+1] = {
            title = "Trigger Export",
            description = "Export: " .. extraConfig.clientexport,
            icon = extraConfig.exportmenuicon or "fas fa-code",
            event = 'cxc_supporthub:triggerExport',
            args = {export = extraConfig.clientexport},
            arrow = true
        }
    end
    
    if extraConfig.guidemenu and extraConfig.guides then
        options[#options+1] = {
            title = "Open Guide",
            description = "Read the guide",
            icon = extraConfig.guidemenuicon or "fas fa-book",
            event = 'cxc_supporthub:openGuideMenu',
            args = {guides = extraConfig.guides},
            arrow = true
        }
    end
    
    if extraConfig.teleportmarkermenu and extraConfig.teleportmarkerlocations then
        options[#options+1] = {
            title = "Teleport",
            description = "Choose a destination",
            icon = extraConfig.teleportmenuicon or "fas fa-map-marker-alt",
            event = 'cxc_supporthub:openTeleportMenu',
            args = {locations = extraConfig.teleportmarkerlocations},
            arrow = true
        }
    end

    return options
end

-- Main context menu handler
RegisterNetEvent('cxc_supporthub:openContextMenu', function(data)
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

-- Extra menu handler
RegisterNetEvent('cxc_supporthub:openExtraMenu', function(args)
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

-- Guide menu handler
RegisterNetEvent('cxc_supporthub:openGuideMenu', function(args)
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
                            TriggerEvent('cxc_supporthub:openBrowser', {url = guide.url})
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

-- Browser open handler
RegisterNetEvent('cxc_supporthub:openBrowser', function(data)
    SendNUIMessage({
        action = 'openBrowser',
        url = data.url
    })
end)

-- Command execute handler
RegisterNetEvent('cxc_supporthub:executeCommand', function(data)
    ExecuteCommand(data.command)
    lib.notify({title = 'Command', description = 'Command executed: /' .. data.command, type = 'inform'})
end)

-- Export trigger handler
RegisterNetEvent('cxc_supporthub:triggerExport', function(data)
    local export = data.export:gsub(':', '')
    if exports[export] then
        local result = exports[export]()
        lib.notify({title = 'Export', description = 'Export triggered: ' .. data.export, type = 'inform'})
    else
        lib.notify({title = 'Error', description = 'Export not found!', type = 'error'})
    end
end)