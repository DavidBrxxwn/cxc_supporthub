local QBCore, ESX, QBox = nil, nil, nil
local _ = function(key, ...) return _(key, ...) end
local function InitializeFramework()
    if Config.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
        if Config.Debug then
            print('Menu Framework loaded: QBCore')
        end
    elseif Config.Framework == 'qbox' then
        QBox = exports['qbox-core']:GetCoreObject()
        if Config.Debug then
            print('Menu Framework loaded: QBox')
        end
    elseif Config.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        if Config.Debug then
            print('Menu Framework loaded: ESX')
        end
    end
end
CreateThread(function()
    InitializeFramework()
end)
local Menu = {}
function Menu.createMenuOptions(menus)
    local options = {}
    for _, menuData in pairs(menus) do
        if menuData.name == 'webhook' and menuData.webhookurl then
            options[#options+1] = {
                title = menuData.title,
                description = menuData.description,
                icon = menuData.icon,
                metadata = menuData.metadata,
                event = 'cxc_supporhub:sendWebhook',
                args = menuData,
                arrow = true
            }
        elseif menuData.name == 'guide' and menuData.guides then
            options[#options+1] = {
                title = menuData.title,
                description = menuData.description,
                icon = menuData.icon,
                metadata = menuData.metadata,
                event = 'cxc_supporhub:openGuideMenu',
                args = menuData,
                arrow = true
            }
        elseif menuData.name == 'teleport' and menuData.teleportwaypointlocations then
            options[#options+1] = {
                title = menuData.title,
                description = menuData.description,
                icon = menuData.icon,
                metadata = menuData.metadata,
                event = 'cxc_supporhub:openTeleportMenu',
                args = menuData,
                arrow = true
            }
        elseif menuData.name == 'command' and menuData.clientcommand then
            options[#options+1] = {
                title = menuData.title,
                description = menuData.description,
                icon = menuData.icon,
                metadata = menuData.metadata,
                event = 'cxc_supporhub:executeCommand',
                args = menuData,
                arrow = true
            }
        elseif menuData.name == 'export' and menuData.clientexport then
            options[#options+1] = {
                title = menuData.title,
                description = menuData.description,
                icon = menuData.icon,
                metadata = menuData.metadata,
                event = 'cxc_supporhub:triggerExport',
                args = menuData,
                arrow = true
            }
        elseif menuData.name == 'item' and menuData.item then
            options[#options+1] = {
                title = menuData.title,
                description = menuData.description,
                icon = menuData.icon,
                metadata = menuData.metadata,
                event = 'cxc_supporhub:receiveItem',
                args = menuData,
                arrow = true
            }
        end
    end
    return options
end
function Menu.showNotification(message, type, title)
    if Config.Notification == 'ox' then
        lib.notify({
            title = title or "Menu",
            description = message,
            type = type or 'inform',
            position = Config.NotificationPosition or "top",
            style = Config.NotificationStyle
        })
    elseif Config.Notification == 'qb' then
        if QBCore then
            QBCore.Functions.Notify(Menu.formatMessage(message), type or 'primary')
        end
    elseif Config.Notification == 'qbx' then
        if QBox then
            QBox.Functions.Notify(Menu.formatMessage(message), type or 'primary')
        end
    elseif Config.Notification == 'esx' then
        if ESX then
            ESX.ShowNotification(Menu.formatMessage(message))
        else
            TriggerEvent('esx:showNotification', Menu.formatMessage(message))
        end
    elseif Config.Notification == 'gta' then
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(message)
        EndTextCommandThefeedPostTicker(false, true)
    end
end
function Menu.formatMessage(message)
    if Config.NotificationPosition and Config.NotificationPosition ~= "top" then
        local positionPrefix = "[" .. Config.NotificationPosition:upper() .. "] "
        return positionPrefix .. message
    end
    return message
end
function Menu.openContextMenu(options, title)
    if Config.Menu == 'ox' then
        lib.registerContext({
            id = 'cxc_supporthub_menu',
            title = title or 'Support Hub',
            options = options
        })
        lib.showContext('cxc_supporthub_menu')
    elseif Config.Menu == 'qb' then
        if QBCore then
            exports['qb-menu']:openMenu(options)
        end
    end
end
function Menu.createGuideOptions(guides)
    local options = {}
    for _, guide in pairs(guides) do
        options[#options+1] = {
            title = guide.title,
            description = guide.description,
            icon = guide.icon,
            metadata = guide.metadata,
            event = 'cxc_supporhub:showGuide',
            args = guide,
            arrow = true
        }
    end
    return options
end
function Menu.createTeleportOptions(locations)
    local options = {}
    for _, location in pairs(locations) do
        options[#options+1] = {
            title = location.title,
            description = location.description,
            icon = location.icon,
            metadata = location.metadata,
            event = 'cxc_supporhub:teleportToLocation',
            args = location,
            arrow = true
        }
    end
    return options
end
return Menu
