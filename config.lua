Config = {
    npcCoords = { 
        {
            model = 'a_m_m_business_01', -- NPC model (character skin)
            scenario = 'WORLD_HUMAN_CLIPBOARD',-- Scenario the NPC performs (e.g., an animation)
            location = vector4(482.83, -1314.19, 29.2, 90.0),-- Position and orientation of the NPC (coordinates + rotation)
            distance = 2.0, -- Maximum interaction distance
            
            -- Icons for different menu options
            eventmenuicon = "fas fa-play-circle",
            browsermenuicon = "fas fa-globe",
            webhookmenuicon = "fas fa-paper-plane",
            guidemenuicon = "fas fa-book-open",
            teleportmenuicon = "fas fa-map-marker-alt",
            commandmenuicon = "fas fa-terminal",
            exportmenuicon = "fas fa-code",
            itemmenuicon = "fas fa-gift",
            extramenuicon = "fas fa-plus-circle",
            
            -- Order of menu items
            menuorder = {
                eventmenu = 1,
                browsermenu = 2,
                webhookmenu = 3,
                guidemenu = 4,
                teleportmarkermenu = 5,
                commandmenu = 6,
                exportmenu = 7,
                itemmenu = 8,
                extramenu = 9,
            },
            
            -- Settings for the event menu
            eventmenu = true, -- Is the event menu enabled?
            clientevent = '', -- Name of the event to be triggered
            
            -- Settings for the browser menu
            browsermenu = true, -- Is the browser menu enabled?
            browserurl = '', -- URL to be opened in the browser
            
            -- Settings for the webhook menu
            webhookmenu = true, -- Is the webhook menu enabled?
            webhookurl = '', -- Webhook URL for external notifications
            
            -- Settings for the command menu
            commandmenu = true, -- Is the command menu enabled?
            clientcommand = '', -- Command to be executed on the client
            
            -- Settings for the export menu
            exportmenu = true, -- Is the export menu enabled?
            clientexport = '', -- Name of the export function
            
            -- Settings for the item menu
            itemmenu = true, -- Is the item menu enabled?
            item = '', -- Name of the item
            
            -- Settings for the guide menu
            guidemenu = true, -- Is the guide menu enabled?
            guides = {
                {
                    title = "Starter Guide", -- Title of the guide
                    description = "Learn the basics of the server", -- Guide description
                    icon = "fas fa-info-circle", -- Icon for the menu
                    image = "https://example.com/starter.jpg", -- Image for the guide
                }
            },
            
            -- Settings for the teleport menu
            teleportmarkermenu = true, -- Is the teleport menu enabled?
            teleportmarker = false, -- Is teleport active?
            teleportmarkerlocations = {
                { 
                    title = "Pit Stop", -- Title of the teleport destination
                    description = "Main location", -- Description
                    icon = "fas fa-warehouse", -- Icon for display
                    location = vector4(922.71, -1551.09, 30.84, 85.57), -- Coordinates for the destination
                    image = "https://example.com/location.jpg" -- Image for the destination
                }
            },
            
            -- Settings for the extra menu
            extramenu = false, -- Is the extra menu enabled?
            extras = {
                { 
                    title = "Premium Features", 
                    description = "Exclusive additional features",
                    icon = "fas fa-crown", -- Icon
                    image = "https://example.com/premium.jpg",
                    commandmenu = true,
                    commandmenuicon = "fas fa-crown",
                    clientcommand = '',
                },
                { 
                    title = "Event Features", 
                    description = "Special events", 
                    eventmenuicon = "fas fa-play-circle",
                    icon = "fas fa-calendar-star",
                    image = "https://example.com/event.jpg",
                    eventmenu = true,
                    eventmenuicon = "fas fa-calendar-star",
                    browserurl = 'https://example.com'
                },
                { 
                    title = "Webhook Features", 
                    description = "Webhook functions", 
                    icon = "fas fa-cloud-upload-alt",
                    image = "https://example.com/event.jpg",
                    webhookmenu = true,
                    webhookmenuicon = "fas fa-cloud-upload-alt",
                    webhookurl = '',
                },
                { 
                    title = "Custom Events", 
                    description = "Special events", 
                    icon = "fas fa-bolt",
                    image = "https://example.com/event.jpg",
                    eventmenu = true,
                    eventmenuicon = "fas fa-bolt",
                    clientevent = 'special-event',
                },
                { 
                    title = "Export Features", 
                    description = "Export functions", 
                    icon = "fas fa-database",
                    image = "https://example.com/event.jpg",
                    exportmenu = true,
                    exportmenuicon = "fas fa-database",
                    clientexport = '',
                },
                { 
                    title = "VIP Teleport", 
                    description = "Exclusive locations", 
                    icon = "fas fa-star",
                    image = "https://example.com/vip.jpg",
                    teleportmarkermenu = true,
                    teleportmenuicon = "fas fa-star",
                    teleportmarker = true,
                    teleportmarkerlocations = {
                        { 
                            title = "VIP Area", 
                            description = "Private area", 
                            icon = "fas fa-lock",
                            location = vector4(-100.0, 200.0, 30.0, 180.0),
                            image = "https://example.com/vip_area.jpg" 
                        }
                    }
                },
                { 
                    title = "Premium Items", 
                    description = "Exclusive items", 
                    icon = "fas fa-gem",
                    image = "https://example.com/items.jpg",
                    itemmenu = true,
                    itemmenuicon = "fas fa-gem",
                    item = 'vipcoin'
                }
            }
        },
        -- Additional NPCs can be added here
    }
}
