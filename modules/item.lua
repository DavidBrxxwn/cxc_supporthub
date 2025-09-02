-- Item Module
-- Handles item receiving functionality

-- Item receive handler
RegisterNetEvent('cxc_supporthub:receiveItem', function(data)
    TriggerServerEvent('cxc_supporthub:giveItem', data.item)
end)