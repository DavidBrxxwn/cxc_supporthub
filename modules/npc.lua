-- NPC Module
-- Handles NPC spawning and targeting setup

local QBCore = exports['qb-core']:GetCoreObject()

local function spawnNPCs()
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
                        event = "cxc_supporthub:openContextMenu",
                        icon = "fas fa-user",
                        label = "Support HUB",
                        npcIndex = npcIndex,
                    }
                },
                distance = npcConfig.distance
            })
        end
    end)
end

-- Initialize NPCs when module loads
spawnNPCs()