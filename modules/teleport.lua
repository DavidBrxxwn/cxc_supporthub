-- Teleport Module
-- Handles teleportation functionality and marker management

local activeMarkers = {}

-- Marker drawing thread
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
                    outline = true,
                    bobUpAndDown = false,
                    faceCam = false,
                })
            end
        end
    end
end)

-- Teleport menu handler
RegisterNetEvent('cxc_supporthub:openTeleportMenu', function(args)
    local npcConfig = Config.npcCoords[args.npcIndex]
    local teleportOptions = {}

    for _, location in ipairs(npcConfig.teleportmarkerlocations) do
        teleportOptions[#teleportOptions+1] = {
            title = location.title,
            description = location.description,
            icon = "fas fa-location-arrow",
            event = 'cxc_supporthub:executeTeleport',
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

-- Execute teleport
RegisterNetEvent('cxc_supporthub:executeTeleport', function(data)
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