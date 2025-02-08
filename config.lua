Config = {
    npcCoords = { 
        {
            model = 'a_m_m_business_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            location = vector4(482.83, -1314.19, 29.2, 90.0),
            distance = 2.0,
            
            eventmenuicon = "fas fa-play-circle",
            browsermenuicon = "fas fa-globe",
            webhookmenuicon = "fas fa-paper-plane",
            guidemenuicon = "fas fa-book-open",
            teleportmenuicon = "fas fa-map-marker-alt",
            commandmenuicon = "fas fa-terminal",
            exportmenuicon = "fas fa-code",
            itemmenuicon = "fas fa-gift",
            extramenuicon = "fas fa-plus-circle",
            
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
            
            eventmenu = true,
            clientevent = '',
            browsermenu = true,
            browserurl = '',
            webhookmenu = true,
            webhookurl = '',
            commandmenu = true,
            clientcommand = '',
            exportmenu = true,
            clientexport = '',
            itemmenu = true,
            item = '',
            guidemenu = true,
            guides = {
                {
                    title = "Starter Guide",
                    description = "Lerne die Grundlagen des Servers",
                    icon = "fas fa-info-circle",
                    image = "https://example.com/starter.jpg",
                }
            },
            teleportmarkermenu = true,
            teleportmarker = false,
            teleportmarkerlocations = {
                { 
                    title = "Pit Stop", 
                    description = "Hauptlocation", 
                    icon = "fas fa-warehouse",
                    location = vector4(922.71, -1551.09, 30.84, 85.57),
                    image = "https://example.com/location.jpg" 
                }
            },
            
            extramenu = false,
            extras = {
                { 
                    title = "Premium Features",
                    description = "Exklusive Zusatzfunktionen",
                    icon = "fas fa-crown",
                    image = "https://example.com/premium.jpg",
                    commandmenu = true,
                    commandmenuicon = "fas fa-crown",
                    clientcommand = '',
                },
                { 
                    title = "Event Features",
                    description = "Spezielle Events",
                    eventmenuicon = "fas fa-play-circle",
                    icon = "fas fa-calendar-star",
                    image = "https://example.com/event.jpg",
                    eventmenu = true,
                    eventmenuicon = "fas fa-calendar-star",
                    browserurl = 'https://example.com'
                },
                { 
                    title = "Webhook Features",
                    description = "Webhook Funktionen",
                    icon = "fas fa-cloud-upload-alt",
                    image = "https://example.com/event.jpg",
                    webhookmenu = true,
                    webhookmenuicon = "fas fa-cloud-upload-alt",
                    webhookurl = '',
                },
                { 
                    title = "Custom Events",
                    description = "Spezielle Events",
                    icon = "fas fa-bolt",
                    image = "https://example.com/event.jpg",
                    eventmenu = true,
                    eventmenuicon = "fas fa-bolt",
                    clientevent = 'special-event',
                },
                { 
                    title = "Export Features",
                    description = "Export Funktionen",
                    icon = "fas fa-database",
                    image = "https://example.com/event.jpg",
                    exportmenu = true,
                    exportmenuicon = "fas fa-database",
                    clientexport = '',
                },
                { 
                    title = "VIP Teleport",
                    description = "Exklusive Locations",
                    icon = "fas fa-star",
                    image = "https://example.com/vip.jpg",
                    teleportmarkermenu = true,
                    teleportmenuicon = "fas fa-star",
                    teleportmarker = true,
                    teleportmarkerlocations = {
                        { 
                            title = "VIP Bereich", 
                            description = "Privater Bereich", 
                            icon = "fas fa-lock",
                            location = vector4(-100.0, 200.0, 30.0, 180.0),
                            image = "https://example.com/vip_area.jpg" 
                        }
                    }
                },
                { 
                    title = "Premium Items",
                    description = "Exklusive Gegenstände",
                    icon = "fas fa-gem",
                    image = "https://example.com/items.jpg",
                    itemmenu = true,
                    itemmenuicon = "fas fa-gem",
                    item = 'vipcoin'
                }
            }
        },
    }
}
