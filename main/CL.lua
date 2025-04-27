local onduty = false
local ondutyjob = nil
local ondutyas = nil

local leoweapons = Config.LEOWeapons
local fireweapons = Config.FIREWeapons

local serverId = PlayerId()

local weapons = {}

local external = Config.External or false

if not external then

TriggerEvent('chat:addSuggestion', '/duty', 'Toggle your duty status for better ImperialCAD notifications', {
    { name="JOB", help="Specify the job you want to go on-duty as or blank for off duty" },
})

RegisterCommand("duty", function(source, args)
    local received = args[1] or nil
    local job = received and string.upper(received) or nil
    
    if onduty then

        onduty = false
        TriggerServerEvent("Imperial:RemoveUnitOnDuty", job)
        ShowNotification("You are now ~r~off-duty~w~.", job)
        
        for _, weapon in ipairs(weapons) do
            RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weapon))
        end
        weapons = {} or nil

    else
        if job == nil then
            ShowNotification("You need to specify a job.", "Imperial Duty")
            return
        end

        onduty = true
        TriggerServerEvent("Imperial:AddUnitOnDuty", job)
        ShowNotification("You are now ~g~on-duty~w~.", job)
        SetPedArmour(PlayerPedId(), 100)

        if job == "LEO" and Config.GiveLEOWeapons then
            weapons = leoweapons
        elseif job == "FIRE" and Config.GiveFIREWeapons then
            weapons = fireweapons
        else
            weapons = {}
        end

        for _, weapon in ipairs(weapons) do
            GiveWeaponToPed(PlayerPedId(), GetHashKey(weapon), 250, false, true)
            SetPedAmmo(PlayerPedId(), GetHashKey(weapon), 250)
        end

    end
end, false)

end

local blips = {}

if Config.Showblips then -- Pre much takes away blip logic if not set to true

RegisterNetEvent("Imperial:ShowBlip")
AddEventHandler("Imperial:ShowBlip", function(serverId, job)
    if not NetworkIsPlayerActive(GetPlayerFromServerId(serverId)) then return end

    local playerJob = ondutyjob 
    if (playerJob == "LEO" and job ~= "LEO") or (playerJob == "FIRE" and job ~= "FIRE") then
        return
    end

    local ped = GetPlayerPed(GetPlayerFromServerId(serverId))
    local blip = AddBlipForEntity(ped)
    
    SetBlipSprite(blip, job == "LEO" and 60 or 153) -- LEO = Blue Circle, Fire = Red Circle
    SetBlipColour(blip, job == "LEO" and 3 or 1) -- LEO = Blue, Fire = Red
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(job == "LEO" and "LEO Unit" or "Fire Unit")
    EndTextCommandSetBlipName(blip)

    blips[serverId] = blip
end)

RegisterNetEvent("Imperial:RemoveBlip")
AddEventHandler("Imperial:RemoveBlip", function(serverId)
    if blips[serverId] then
        RemoveBlip(blips[serverId])
        blips[serverId] = nil
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000) 
        if onduty then
            local coords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent("Imperial:UpdateBlip", coords)
        end
    end
end)

RegisterNetEvent("Imperial:SyncBlips")
AddEventHandler("Imperial:SyncBlips", function(serverId, coords, job)
    if blips[serverId] then
        SetBlipCoords(blips[serverId], coords.x, coords.y, coords.z)
    end
end)

end

function ShowNotification(message, job)  
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostMessagetext("CHAR_CHAT_CALL", "CHAR_CHAT_CALL", true, 1, "ImperialCAD", job)
end