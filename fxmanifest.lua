fx_version 'cerulean'
game 'gta5'

name 'ImperialDuty'
description 'ImperialCAD Notification and user management for on-duty units.'
author 'Imperial Solutions'
version '2.0.1'

shared_scripts {
    'CONFIG.lua'
}

client_scripts {
    'main/CL.lua'
}

server_scripts {
    'main/SV.lua'
}

server_export 'GetOnDutyUnits'
