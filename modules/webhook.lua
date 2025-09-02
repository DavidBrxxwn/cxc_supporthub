-- Webhook Module
-- Handles webhook sending functionality

-- Webhook send handler
RegisterNetEvent('cxc_supporthub:sendWebhook', function(data)
    local input = lib.inputDialog('Webhook Message', {
        {type = 'input', label = 'Your Message', required = true, min = 5, name = 'message'}
    })

    if input then
        local message = input[1]
        TriggerServerEvent('cxc_supporthub:triggerWebhook', data.url, message)
    else
        lib.notify({title = 'Cancelled', description = 'You did not enter a message', type = 'error'})
    end
end)