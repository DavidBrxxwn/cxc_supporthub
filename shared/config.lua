-- Author: David Brxxwn | Cxmmunity Club
-- Discord: https://discord.com/invite/EcpCFyX4DC

Config = {}
Config.Debug = true
Config.Framework = "qb-core" -- qb-core
Config.Target = "ox_target" -- qb-core

Config.Notification = {
    position = "top",  -- e.g. "top-right", "top-left", "bottom-right", "bottom-left", "center-right", etc. or false for ox_lib default
    style = false,
    --[[
    style = {
        backgroundColor = "#000000ff", -- Background color (Hex/CSS)
        color = "#ffffff",           -- Text color (Hex/CSS)
        borderRadius = "8px",        -- Corner radius
        fontSize = "16px",           -- Font size
        -- more CSS properties as needed!
    } -- or false, then ox_lib default will be used --]]
}

Config.Zones = {
    [1] = {
        id = "zone1",
        zone = {
            coords = vector4(-1299.52, -3407.39, 13.94, 333.39),
            radius = 5.0
        },
        notifications = {
            title = "Notice",
            enter = "You are now in Showroom 3.",
            leave = "You have left Showroom 3."
        }, -- or false,
        blips = {
            [1] = {
                label = "test",
                coords = vector3(444.66, -978.83, 30.71),
                sprite = 225,
                color = 6,
                scale = 0.8,
                shortRange = true,
            } -- or false,
        },
        npcs = {
            [1] = {
                label = "Support NPC",
                icon = "fas fa-user",
                model = 'a_m_m_business_01', -- NPC model (character skin)
                scenario = 'WORLD_HUMAN_CLIPBOARD',-- Scenario the NPC performs (e.g., an animation)
                location = vector4(-1299.52, -3407.39, 13.94, 333.39),-- Position and orientation of the NPC (coordinates + rotation)
                distance = 2.0, -- Maximum interaction distance
            }
        },
        menus = {
            [1] = {
                name = "webhook",
                title = "Contact Admin",
                description = "Send a message to the support team.",
                icon = "fas fa-paper-plane",
                metadata = { "Send a message to the support team."},
                webhookurl = '', -- Webhook URL for external notifications
                embed = {
                    title = "**SUPPORT**",
                    color = 16711680,
                    fields = {
                        {name = "Player", value = "{player}", inline = true},
                        {name = "ID", value = "{id}", inline = true},
                        {name = "Message", value = "{message}"}
                    },
                    footer = {text = "{date}"}
                }
            },
            [2] = {
                name = "guide",
                title = "Guides & Help",
                description = "Read guides and help texts.",
                icon = "fas fa-book-open",
                metadata = { "Read guides and help texts." },
                guides = {
                    [1] = {
                        title = "Starter Guide", -- Title of the guide
                        description = "Learn the basics of the server", -- Guide description
                        icon = "fas fa-info-circle", -- Icon for the menu
                        metadata = { "Learn the basics of the server" },
                        image = "https://example.com/starter.jpg", -- Image for the guide
                        arrow = true,

                        header = "Starter Guide", -- Header for the guide
                        content = "This is the content of the starter guide.",
                        size = 'xl', -- changed from 'xl' to 'md'
                        centered = false, -- Centers the dialog vertically and horizontally.
                        overflow = false, -- overflow?: boolean
                        cancel = false,
                        labels = { confirm = "Continue", cancel = "Cancel" },
                        option = 4, -- 1 command ,  2 export , 3 item , 4 menu -- or false
                        event = 'guide_menu', -- 1 command ,  2 export , 3 item
                    }
                },
            },
            [3] = {
                name = "teleport",
                title = "Teleport",
                description = "Choose a destination to teleport.",
                icon = "fas fa-map-marker-alt",
                metadata = { "Choose a destination to teleport." },
                teleportwaypointlocations = {
                    [1] = { 
                        title = "Pit Stop", -- Title of the teleport destination
                        description = "Main location", -- Description
                        icon = "fas fa-warehouse", -- Icon for display
                        metadata = { "Main location" },
                        image = "https://example.com/location.jpg", -- Image for the destination
                        location = vector4(922.71, -1551.09, 30.84, 85.57), -- Coordinates for the destination
                        arrow = true,

                        header = "Starter Guide", -- Header for the guide
                        content = "This is the content of the starter guide.",
                        size = 'xl', -- size?: 'xs' or 'sm' or 'md' or 'lg' or 'xl'
                        centered = false, -- Centers the dialog vertically and horizontally.
                        overflow = false, -- overflow?: boolean
                        cancel = false,
                        labels = { confirm = "Continue", cancel = "Cancel" },
                        option = 2, -- 1 teleport ,  2 waypoint
                    },
                },
            },
            [4] = {
                name = "command",
                title = "Execute Command",
                description = "Execute a client command.",
                icon = "fas fa-terminal",
                metadata = { "Execute a client command." },
                clientcommand = 'tutorial', -- Command to be executed on the client
            },
            [5] = {
                name = "export",
                title = "Trigger Export",
                description = "Start an export trigger.",
                icon = "fas fa-code",
                metadata = { "Start an export trigger." },
                clientexport = 'help', -- Name of the export function
            },
            [6] = {
                name = "item",
                title = "Receive Item",
                description = "Receive an item.",
                icon = "fas fa-gift",
                metadata = { "Receive an item." },
                claimableOncePerRestart = true, -- Item can be claimed only once per server restart
                item = { [1] = { name = 'sandwich', label = "Sandwich", amount = 1 }, },
            },
            -- you need more menus? create them here
            [7] = {
                name = "webhook",
                title = "Contact Admin",
                description = "Send a message to the support team.",
                icon = "fas fa-paper-plane",
                metadata = { "Send a message to the support team." },
                webhookurl = '', -- Webhook URL for external notifications
            },
        },
    },
}