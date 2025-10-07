-- English translations
local en = {
    -- General Terms
    ['unknown'] = 'Unknown',
    ['loading'] = 'Loading...',
    ['error'] = 'Error',
    ['success'] = 'Success',
    ['warning'] = 'Warning',
    ['info'] = 'Information',
    
    -- Notifications
    ['teleport_title'] = 'Teleport',
    ['teleport_success'] = 'Successfully teleported!',
    ['waypoint_title'] = 'Waypoint Set',
    ['waypoint_success'] = 'Destination marked on the map!',
    ['cancelled_title'] = 'Cancelled',
    ['no_message_entered'] = 'You did not enter a message',
    ['command_title'] = 'Command',
    ['command_executed'] = 'Command executed: /%s',
    ['invalid_command'] = 'Invalid command!',
    ['export_title'] = 'Export',
    ['export_triggered'] = 'Export triggered: %s',
    ['export_not_found'] = 'Export not found!',
    ['not_claimable'] = 'Not claimable',
    ['already_claimed'] = 'You have already claimed this item!',
    ['item_received'] = 'Item received',
    ['received_items'] = 'You received %sx %s',
    ['item_not_exist'] = 'This item does not exist!'
}

-- German translations
local de = {
    -- General Terms
    ['unknown'] = 'Unbekannt',
    ['loading'] = 'Lädt...',
    ['error'] = 'Fehler',
    ['success'] = 'Erfolg',
    ['warning'] = 'Warnung',
    ['info'] = 'Information',
    
    -- Notifications
    ['teleport_title'] = 'Teleport',
    ['teleport_success'] = 'Erfolgreich teleportiert!',
    ['waypoint_title'] = 'Wegpunkt gesetzt',
    ['waypoint_success'] = 'Ziel auf der Karte markiert!',
    ['cancelled_title'] = 'Abgebrochen',
    ['no_message_entered'] = 'Sie haben keine Nachricht eingegeben',
    ['command_title'] = 'Befehl',
    ['command_executed'] = 'Befehl ausgeführt: /%s',
    ['invalid_command'] = 'Ungültiger Befehl!',
    ['export_title'] = 'Export',
    ['export_triggered'] = 'Export ausgelöst: %s',
    ['export_not_found'] = 'Export nicht gefunden!',
    ['not_claimable'] = 'Nicht einlösbar',
    ['already_claimed'] = 'Sie haben diesen Gegenstand bereits erhalten!',
    ['item_received'] = 'Gegenstand erhalten',
    ['received_items'] = 'Sie haben %sx %s erhalten',
    ['item_not_exist'] = 'Dieser Gegenstand existiert nicht!'
}

-- French translations
local fr = {
    -- General Terms
    ['unknown'] = 'Inconnu',
    ['loading'] = 'Chargement...',
    ['error'] = 'Erreur',
    ['success'] = 'Succès',
    ['warning'] = 'Avertissement',
    ['info'] = 'Information',
    
    -- Notifications
    ['teleport_title'] = 'Téléportation',
    ['teleport_success'] = 'Téléporté avec succès!',
    ['waypoint_title'] = 'Point de cheminement défini',
    ['waypoint_success'] = 'Destination marquée sur la carte!',
    ['cancelled_title'] = 'Annulé',
    ['no_message_entered'] = 'Vous n\'avez pas saisi de message',
    ['command_title'] = 'Commande',
    ['command_executed'] = 'Commande exécutée: /%s',
    ['invalid_command'] = 'Commande invalide!',
    ['export_title'] = 'Export',
    ['export_triggered'] = 'Export déclenché: %s',
    ['export_not_found'] = 'Export non trouvé!',
    ['not_claimable'] = 'Non récupérable',
    ['already_claimed'] = 'Vous avez déjà récupéré cet objet!',
    ['item_received'] = 'Objet reçu',
    ['received_items'] = 'Vous avez reçu %sx %s',
    ['item_not_exist'] = 'Cet objet n\'existe pas!'
}

-- Spanish translations
local es = {
    -- General Terms
    ['unknown'] = 'Desconocido',
    ['loading'] = 'Cargando...',
    ['error'] = 'Error',
    ['success'] = 'Éxito',
    ['warning'] = 'Advertencia',
    ['info'] = 'Información',
    
    -- Notifications
    ['teleport_title'] = 'Teletransporte',
    ['teleport_success'] = '¡Teletransportado exitosamente!',
    ['waypoint_title'] = 'Punto de ruta establecido',
    ['waypoint_success'] = '¡Destino marcado en el mapa!',
    ['cancelled_title'] = 'Cancelado',
    ['no_message_entered'] = 'No ingresaste un mensaje',
    ['command_title'] = 'Comando',
    ['command_executed'] = 'Comando ejecutado: /%s',
    ['invalid_command'] = '¡Comando inválido!',
    ['export_title'] = 'Export',
    ['export_triggered'] = 'Export activado: %s',
    ['export_not_found'] = '¡Export no encontrado!',
    ['not_claimable'] = 'No reclamable',
    ['already_claimed'] = '¡Ya has reclamado este artículo!',
    ['item_received'] = 'Artículo recibido',
    ['received_items'] = 'Recibiste %sx %s',
    ['item_not_exist'] = '¡Este artículo no existe!'
}

function _(key, ...)
    local locale = Config.Locale or 'en'
    local translations = en -- Default to English
    
    if locale == 'de' then
        translations = de
    elseif locale == 'fr' then
        translations = fr
    elseif locale == 'es' then
        translations = es
    end
    
    local phrase = translations[key] or key
    
    if ... then
        return string.format(phrase, ...)
    end
    
    return phrase
end
