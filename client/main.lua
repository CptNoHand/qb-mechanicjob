QBCore = exports['qb-core']:GetCoreObject()

--local ModdedVehicles = {}
VehicleStatus = {}
local PlayerJob = {}
local onDuty = false
local effectTimer = 0

-- Exports

local function GetVehicleStatusList(plate)
    local retval = nil
    if VehicleStatus[plate] ~= nil then
        retval = VehicleStatus[plate]
    end
    return retval
end

local function GetVehicleStatus(plate, part)
    local retval = nil
    if VehicleStatus[plate] ~= nil then
        retval = VehicleStatus[plate][part]
    end
    return retval
end

local function SetVehicleStatus(plate, part, level)
    TriggerServerEvent("vehiclemod:server:updatePart", plate, part, level)
end

exports('GetVehicleStatusList', GetVehicleStatusList)
exports('GetVehicleStatus', GetVehicleStatus)
exports('SetVehicleStatus', SetVehicleStatus)

-- Functions

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function ScrapAnim(time)
    local time = time / 1000
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Wait(2000)
            time = time - 2
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

local function ApplyEffects(vehicle)
    local plate = QBCore.Functions.GetPlate(vehicle)
    if GetVehicleClass(vehicle) ~= 13 and GetVehicleClass(vehicle) ~= 21 and GetVehicleClass(vehicle) ~= 16 and GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 14 then
        if VehicleStatus[plate] ~= nil then
            local chance = math.random(1, 100)
            if VehicleStatus[plate]["radiator"] <= 80 and (chance >= 1 and chance <= 20) then
                local engineHealth = GetVehicleEngineHealth(vehicle)
                if VehicleStatus[plate]["radiator"] <= 80 and VehicleStatus[plate]["radiator"] >= 60 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(10, 15))
                elseif VehicleStatus[plate]["radiator"] <= 59 and VehicleStatus[plate]["radiator"] >= 40 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(15, 20))
                elseif VehicleStatus[plate]["radiator"] <= 39 and VehicleStatus[plate]["radiator"] >= 20 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(20, 30))
                elseif VehicleStatus[plate]["radiator"] <= 19 and VehicleStatus[plate]["radiator"] >= 6 then
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(30, 40))
                else
                    SetVehicleEngineHealth(vehicle, engineHealth - math.random(40, 50))
                end
            end

            if VehicleStatus[plate]["axle"] <= 80 and (chance >= 21 and chance <= 40) then
                if VehicleStatus[plate]["axle"] <= 80 and VehicleStatus[plate]["axle"] >= 60 then
                    for i=0,360 do
                        SetVehicleSteeringScale(vehicle,i)
                        Wait(5)
                    end
                elseif VehicleStatus[plate]["axle"] <= 59 and VehicleStatus[plate]["axle"] >= 40 then
                    for i=0,360 do
                        Wait(10)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                elseif VehicleStatus[plate]["axle"] <= 39 and VehicleStatus[plate]["axle"] >= 20 then
                    for i=0,360 do
                        Wait(15)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                elseif VehicleStatus[plate]["axle"] <= 19 and VehicleStatus[plate]["axle"] >= 6 then
                    for i=0,360 do
                        Wait(20)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                else
                    for i=0,360 do
                        Wait(25)
                        SetVehicleSteeringScale(vehicle,i)
                    end
                end
            end

            if VehicleStatus[plate]["brakes"] <= 80 and (chance >= 41 and chance <= 60) then
                if VehicleStatus[plate]["brakes"] <= 80 and VehicleStatus[plate]["brakes"] >= 60 then
                    SetVehicleHandbrake(vehicle, true)
                    Wait(1000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["brakes"] <= 59 and VehicleStatus[plate]["brakes"] >= 40 then
                    SetVehicleHandbrake(vehicle, true)
                    Wait(3000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["brakes"] <= 39 and VehicleStatus[plate]["brakes"] >= 20 then
                    SetVehicleHandbrake(vehicle, true)
                    Wait(5000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["brakes"] <= 19 and VehicleStatus[plate]["brakes"] >= 6 then
                    SetVehicleHandbrake(vehicle, true)
                    Wait(7000)
                    SetVehicleHandbrake(vehicle, false)
                else
                    SetVehicleHandbrake(vehicle, true)
                    Wait(9000)
                    SetVehicleHandbrake(vehicle, false)
                end
            end

            if VehicleStatus[plate]["clutch"] <= 80 and (chance >= 61 and chance <= 80) then
                if VehicleStatus[plate]["clutch"] <= 80 and VehicleStatus[plate]["clutch"] >= 60 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Wait(50)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Wait(5)
                    end
                    Wait(500)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["clutch"] <= 59 and VehicleStatus[plate]["clutch"] >= 40 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Wait(100)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Wait(5)
                    end
                    Wait(750)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["clutch"] <= 39 and VehicleStatus[plate]["clutch"] >= 20 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Wait(150)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Wait(5)
                    end
                    Wait(1000)
                    SetVehicleHandbrake(vehicle, false)
                elseif VehicleStatus[plate]["clutch"] <= 19 and VehicleStatus[plate]["clutch"] >= 6 then
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Wait(200)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Wait(5)
                    end
                    Wait(1250)
                    SetVehicleHandbrake(vehicle, false)
                else
                    SetVehicleHandbrake(vehicle, true)
                    SetVehicleEngineOn(vehicle,0,0,1)
                    SetVehicleUndriveable(vehicle,true)
                    Wait(250)
                    SetVehicleEngineOn(vehicle,1,0,1)
                    SetVehicleUndriveable(vehicle,false)
                    for i=1,360 do
                        SetVehicleSteeringScale(vehicle, i)
                        Wait(5)
                    end
                    Wait(1500)
                    SetVehicleHandbrake(vehicle, false)
                end
            end

            if VehicleStatus[plate]["fuel"] <= 80 and (chance >= 81 and chance <= 100) then
                local fuel = exports['LegacyFuel']:GetFuel(vehicle)
                if VehicleStatus[plate]["fuel"] <= 80 and VehicleStatus[plate]["fuel"] >= 60 then
                    exports['LegacyFuel']:SetFuel(vehicle, fuel - 2.0)
                elseif VehicleStatus[plate]["fuel"] <= 59 and VehicleStatus[plate]["fuel"] >= 40 then
                    exports['LegacyFuel']:SetFuel(vehicle, fuel - 4.0)
                elseif VehicleStatus[plate]["fuel"] <= 39 and VehicleStatus[plate]["fuel"] >= 20 then
                    exports['LegacyFuel']:SetFuel(vehicle, fuel - 6.0)
                elseif VehicleStatus[plate]["fuel"] <= 19 and VehicleStatus[plate]["fuel"] >= 6 then
                    exports['LegacyFuel']:SetFuel(vehicle, fuel - 8.0)
                else
                    exports['LegacyFuel']:SetFuel(vehicle, fuel - 10.0)
                end
            end
        end
    end
end

local function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 1) .. "f", num))
end

local function SendStatusMessage(statusList)
    if statusList ~= nil then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message normal"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>'.. Config.ValuesLabels["engine"] ..' (engine):</strong> {1} <br><strong>'.. Config.ValuesLabels["body"] ..' (body):</strong> {2} <br><strong>'.. Config.ValuesLabels["radiator"] ..' (radiator):</strong> {3} <br><strong>'.. Config.ValuesLabels["axle"] ..' (axle):</strong> {4}<br><strong>'.. Config.ValuesLabels["brakes"] ..' (brakes):</strong> {5}<br><strong>'.. Config.ValuesLabels["clutch"] ..' (clutch):</strong> {6}<br><strong>'.. Config.ValuesLabels["fuel"] ..' (fuel):</strong> {7}</div></div>',
            args = {'Vehicle Status', round(statusList["engine"]) .. "/" .. Config.MaxStatusValues["engine"] .. " ("..QBCore.Shared.Items["advancedrepairkit"]["label"]..")", round(statusList["body"]) .. "/" .. Config.MaxStatusValues["body"] .. " ("..QBCore.Shared.Items[Config.RepairCost["body"]]["label"]..")", round(statusList["radiator"]) .. "/" .. Config.MaxStatusValues["radiator"] .. ".0 ("..QBCore.Shared.Items[Config.RepairCost["radiator"]]["label"]..")", round(statusList["axle"]) .. "/" .. Config.MaxStatusValues["axle"] .. ".0 ("..QBCore.Shared.Items[Config.RepairCost["axle"]]["label"]..")", round(statusList["brakes"]) .. "/" .. Config.MaxStatusValues["brakes"] .. ".0 ("..QBCore.Shared.Items[Config.RepairCost["brakes"]]["label"]..")", round(statusList["clutch"]) .. "/" .. Config.MaxStatusValues["clutch"] .. ".0 ("..QBCore.Shared.Items[Config.RepairCost["clutch"]]["label"]..")", round(statusList["fuel"]) .. "/" .. Config.MaxStatusValues["fuel"] .. ".0 ("..QBCore.Shared.Items[Config.RepairCost["fuel"]]["label"]..")"}
        })
    end
end

local function SpawnListVehicle(model)
    local coords = {
        x = Config.Locations["vehicle"].x,
        y = Config.Locations["vehicle"].y,
        z = Config.Locations["vehicle"].z,
        w = Config.Locations["vehicle"].w,
    }

    QBCore.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, "ACBV"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

local function VehicleList()
    local vehicleMenu = {
        {
            header = "Vehicle List",
            isMenuHeader = true
        }
    }
    for k,v in pairs(Config.Vehicles) do
        vehicleMenu[#vehicleMenu+1] = {
            header = v,
            txt = "Vehicle: "..v.."",
            params = {
                event = "qb-mechanicjob:client:SpawnListVehicle",
                args = {
                    headername = v,
                    spawnName = k
                }
            }
        }                              
    end
    vehicleMenu[#vehicleMenu+1] = {
        header = "⬅ Close Menu",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

local function CheckStatus()
    local plate = QBCore.Functions.GetPlate(Config.Plates[ClosestPlate].AttachedVehicle)
    SendStatusMessage(VehicleStatus[plate])
end



-- Events

RegisterNetEvent("qb-mechanicjob:client:NoDamage",function(data)
    NoDamage()
end)

RegisterNetEvent("qb-mechanicjob:client:CheckStatus",function(data)
    CheckStatus()
end)

RegisterNetEvent("qb-mechanicjob:client:SpawnListVehicle",function(data)
    local vehicleSpawnName=data.spawnName
    SpawnListVehicle(vehicleSpawnName)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.name == "mechanic" then
                TriggerServerEvent("QBCore:ToggleDuty")
            end
        end
    end)
    QBCore.Functions.TriggerCallback('qb-vehicletuning:server:GetAttachedVehicle', function(plates)
        for k, v in pairs(plates) do
            Config.Plates[k].AttachedVehicle = v.AttachedVehicle
        end
    end)

    QBCore.Functions.TriggerCallback('qb-vehicletuning:server:GetDrivingDistances', function(retval)
        DrivingDistance = retval
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

RegisterNetEvent('vehiclemod:client:setVehicleStatus', function(plate, status)
    VehicleStatus[plate] = status
end)

RegisterNetEvent('vehiclemod:client:getVehicleStatus', function(plate, status)
    if not (IsPedInAnyVehicle(PlayerPedId(), false)) then
        local veh = GetVehiclePedIsIn(PlayerPedId(), true)
        if veh ~= nil and veh ~= 0 then
            local vehpos = GetEntityCoords(veh)
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - vehpos) < 5.0 then
                if not IsThisModelABicycle(GetEntityModel(veh)) then
                    local plate = QBCore.Functions.GetPlate(veh)
                    if VehicleStatus[plate] ~= nil then
                        SendStatusMessage(VehicleStatus[plate])
                    else
                        QBCore.Functions.Notify("Status Unknown", "error")
                    end
                else
                    QBCore.Functions.Notify("Not A Valid Vehicle", "error")
                end
            else
                QBCore.Functions.Notify("You Are Not Close Enough To The Vehicle", "error")
            end
        else
            QBCore.Functions.Notify("You Must Be In The Vehicle First", "error")
        end
    else
        QBCore.Functions.Notify("You Must Be Outside The Vehicle", "error")
    end
end)

RegisterNetEvent('vehiclemod:client:fixEverything', function()
    if (IsPedInAnyVehicle(PlayerPedId(), false)) then
        local veh = GetVehiclePedIsIn(PlayerPedId(),false)
        if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
            local plate = QBCore.Functions.GetPlate(veh)
            TriggerServerEvent("vehiclemod:server:fixEverything", plate)
        else
            QBCore.Functions.Notify("You Are Not The Driver Or On A Bicycle", "error")
        end
    else
        QBCore.Functions.Notify("You Are Not In A Vehicle", "error")
    end
end)

RegisterNetEvent('vehiclemod:client:setPartLevel', function(part, level)
    if (IsPedInAnyVehicle(PlayerPedId(), false)) then
        local veh = GetVehiclePedIsIn(PlayerPedId(),false)
        if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
            local plate = QBCore.Functions.GetPlate(veh)
            if part == "engine" then
                SetVehicleEngineHealth(veh, level)
                TriggerServerEvent("vehiclemod:server:updatePart", plate, "engine", GetVehicleEngineHealth(veh))
            elseif part == "body" then
                SetVehicleBodyHealth(veh, level)
                TriggerServerEvent("vehiclemod:server:updatePart", plate, "body", GetVehicleBodyHealth(veh))
            else
                TriggerServerEvent("vehiclemod:server:updatePart", plate, part, level)
            end
        else
            QBCore.Functions.Notify("You Are Not The Driver Or On A Bicycle", "error")
        end
    else
        QBCore.Functions.Notify("You Are Not The Driver Or On A Bicycle", "error")
    end
end)
local openingDoor = false

-- Threads

CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            SetClosestPlate()
        end
        Wait(1000)
    end
end)

CreateThread(function()
    local c = Config.Locations["exit"]
    local Blip = AddBlipForCoord(c.x, c.y, c.z)
    SetBlipSprite (Blip, 446)
    SetBlipDisplay(Blip, 4)
    SetBlipScale  (Blip, 0.7)
    SetBlipAsShortRange(Blip, true)
    SetBlipColour(Blip, 0)
    SetBlipAlpha(Blip, 0.7)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Autocare Mechanic")
    EndTextCommandSetBlipName(Blip)
end)

CreateThread(function()
    while true do
        local inRange = false
        if LocalPlayer.state.isLoggedIn then
            if PlayerJob.name == "mechanic" then
                local pos = GetEntityCoords(PlayerPedId())
                local StashDistance = #(pos - Config.Locations["stash"])
                local OnDutyDistance = #(pos - Config.Locations["duty"])
                local VehicleDistance = #(pos - vector3(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z))

                if onDuty then
                    if StashDistance < 20 then
                        inRange = true
                        DrawMarker(2, Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

                        if StashDistance < 1 then
                            DrawText3Ds(Config.Locations["stash"].x, Config.Locations["stash"].y, Config.Locations["stash"].z, "[E] Open Stash")
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("inventory:client:SetCurrentStash", "mechanicstash")
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "mechanicstash", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                            end
                        end
                    end
                end

                if onDuty then
                    if VehicleDistance < 20 then
                        inRange = true
                        DrawMarker(2, Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                        if VehicleDistance < 1 then
                            local InVehicle = IsPedInAnyVehicle(PlayerPedId())

                            if InVehicle then
                                DrawText3Ds(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, '[E] Hide Vehicle')
                                if IsControlJustPressed(0, 38) then
                                    DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                end
                            else
                                DrawText3Ds(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, '[E] Get Vehicle')
                                if IsControlJustPressed(0, 38) then
                                    if IsControlJustPressed(0, 38) then
                                        VehicleList()
                                    end
                                end
                            end
                        end
                    end
                end

                if OnDutyDistance < 20 then
                    inRange = true
                    DrawMarker(2, Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

                    if OnDutyDistance < 1 then
                        if onDuty then
                            DrawText3Ds(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "[E] Off Duty")
                        else
                            DrawText3Ds(Config.Locations["duty"].x, Config.Locations["duty"].y, Config.Locations["duty"].z, "[E] On Duty")
                        end
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent("QBCore:ToggleDuty")
                        end
                    end
                end
            else
                Wait(1500)
            end
        else
            Wait(1500)
        end

        Wait(3)
    end
end)

-- CreateThread(function() -- Not event sure what this is even for
--     while true do
--         Wait(1)
--         if (IsPedInAnyVehicle(PlayerPedId(), false)) then
--             local veh = GetVehiclePedIsIn(PlayerPedId(),false)
--             if ModdedVehicles[tostring(veh)] == nil and not IsThisModelABicycle(GetEntityModel(veh)) then
--                 --[[local fSteeringLock = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock')
--                 fSteeringLock = math.ceil((fSteeringLock * 0.6)) + 0.1

--                 SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock', fSteeringLock)
--                 SetVehicleHandlingField(veh, 'CHandlingData', 'fSteeringLock', fSteeringLock)]]--

--                 local fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel')

--                 if IsThisModelABike(GetEntityModel(veh)) then
--                     local fTractionCurveMin = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMin')

--                     fTractionCurveMin = fTractionCurveMin * 0.6
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMin', fTractionCurveMin)
--                     SetVehicleHandlingField(veh, 'CHandlingData', 'fTractionCurveMin', fTractionCurveMin)

--                     -- local fTractionCurveMax = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMax')
--                     -- fTractionCurveMax = fTractionCurveMax * 0.6
--                     -- SetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMax', fTractionCurveMax)
--                     -- SetVehicleHandlingField(veh, 'CHandlingData', 'fTractionCurveMax', fTractionCurveMax)

--                     local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
--                     fInitialDriveForce = fInitialDriveForce * 2.4
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)

--                     local fBrakeForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce')
--                     fBrakeForce = fBrakeForce * 1.4
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce', fBrakeForce)

--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionReboundDamp', 5.000000)
--                     SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionReboundDamp', 5.000000)

--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionCompDamp', 5.000000)
--                     SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionCompDamp', 5.000000)

--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionForce', 22.000000)
--                     SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionForce', 22.000000)

--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fCollisionDamageMult', 2.500000)
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fEngineDamageMult', 0.120000)
--                 else
--                     local fBrakeForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce')
--                     fBrakeForce = fBrakeForce * 0.5
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce', fBrakeForce)

--                     local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
--                     if fInitialDriveForce < 0.289 then
--                         fInitialDriveForce = fInitialDriveForce * 1.2
--                         SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)
--                     else
--                         fInitialDriveForce = fInitialDriveForce * 0.9
--                         SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)
--                     end

--                     local fInitialDragCoeff = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff')
--                     fInitialDragCoeff = fInitialDragCoeff * 0.3
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff', fInitialDragCoeff)

--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fEngineDamageMult', 0.100000)
--                     SetVehicleHandlingFloat(veh, 'CHandlingData', 'fCollisionDamageMult', 2.900000)

--                 end
--                 SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDeformationDamageMult', 1.000000)
--                 SetVehicleHasBeenOwnedByPlayer(veh,true)
--                 ModdedVehicles[tostring(veh)] = {
--                     ["fInitialDriveMaxFlatVel"] = fInitialDriveMaxFlatVel,
--                     ["fSteeringLock"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock'),
--                     ["fTractionLossMult"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionLossMult'),
--                     ["fLowSpeedTractionLossMult"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult')
--                 }
--             else
--                 Wait(1000)
--             end
--         else
--             Wait(2000)
--         end
--     end
-- end)

CreateThread(function()
    while true do
        Wait(1000)
        if (IsPedInAnyVehicle(PlayerPedId(), false)) then
            local veh = GetVehiclePedIsIn(PlayerPedId(),false)
            if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                local engineHealth = GetVehicleEngineHealth(veh)
                local bodyHealth = GetVehicleBodyHealth(veh)
                local plate = QBCore.Functions.GetPlate(veh)
                if VehicleStatus[plate] == nil then
                    TriggerServerEvent("vehiclemod:server:setupVehicleStatus", plate, engineHealth, bodyHealth)
                else
                    TriggerServerEvent("vehiclemod:server:updatePart", plate, "engine", engineHealth)
                    TriggerServerEvent("vehiclemod:server:updatePart", plate, "body", bodyHealth)
                    effectTimer = effectTimer + 1
                    if effectTimer >= math.random(10, 15) then
                        ApplyEffects(veh)
                        effectTimer = 0
                    end
                end
            else
                effectTimer = 0
                Wait(1000)
            end
        else
            effectTimer = 0
            Wait(2000)
        end
    end
end)