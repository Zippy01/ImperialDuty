Config = {} -- Don't touch this line

Config.External = false -- Enabling this basically just listens for its events to mark users duty for in-game notis and prevents our command from registering

Config.GiveLEOWeapons = true -- If you want to give weapons to the players who go on duty as LEO

Config.LEOWeapons = {
    "WEAPON_COMBATPISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_NIGHTSTICK",
    "WEAPON_FLASHLIGHT",
    "WEAPON_CARBINERIFLE",
    "WEAPON_FIREEXTINGUISHER",
    "WEAPON_PUMPSHOTGUN"
}

Config.GiveFIREWeapons = true -- If you want to give weapons to the players who go on duty as FIRE

Config.FIREWeapons = {
    "WEAPON_FIREEXTINGUISHER",
}

Config.Showblips = false -- If you want to show blips for people with the same job

Config.SendWebhook = false -- If you want to send a webhook when someone goes on/off duty

Config.WebhookURL = "WEBHOOK URL HERE" -- Webhook URL