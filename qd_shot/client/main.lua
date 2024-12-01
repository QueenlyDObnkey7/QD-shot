local keys = {
    ['G1'] = 0x760A9C6F, ['S'] = 0xD27782E3, 
    ['W'] = 0x8FD015D8, ['H'] = 0x24978A28, 
    ['G2'] = 0x5415BE48, ["ENTER"] = 0xC7B5340A, 
    ['E'] = 0xDFF812F9
}

local hurt = 0
local isHurt = false

-- Utility function for requesting models
function requestModel(model)
    Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
    end)
end

-- Helper to reset player state
function resetPlayerEffects()
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    ClearTimecycleModifier()
    SetEntityMotionBlur(playerPed, false)
    SetPedAccuracy(playerPed, 100)
    SetPedIsDrunk(playerPed, false)
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
end

-- Effect application based on hurt type
function applyHurtEffect(type)
    if type == "leg" or type == "arm" then
        hurt = hurt + 80
    end
end



-- Damage monitoring and reaction
Citizen.CreateThread(function()
    while true do
        Wait(500)
        local playerPed = PlayerPedId()
        if HasEntityBeenDamagedByAnyPed(playerPed) then
            local _, boneId = GetPedLastDamageBone(playerPed)
            
            for _, armBone in pairs(Config.arm or {}) do
                if boneId == armBone then
                    if math.random(1, 50) > 30 then
                        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
                        Citizen.InvokeNative(0x89F5E7ADECCCB49C, playerPed, "injured_right_arm")
                        Citizen.InvokeNative(0x46DF918788CB093F, playerPed, "PD_Animal_attack_blood_body_upper_left", true, true)
                    end
                end
            end

            for _, legBone in pairs(Config.leg or {}) do
                if boneId == legBone then
                    if math.random(1, 50) > 25 then
                        SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
                        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
                    end
                end
            end

            ClearEntityLastDamageEntity(playerPed)
        end
    end
end)

-- Hurt state handler
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        if hurt > 0 then
            if not isHurt then
                SetEntityMotionBlur(playerPed, true)
                SetTimecycleModifier("PlayerDrunk01")
                SetPedIsDrunk(playerPed, true)
                ShakeGameplayCam("DRUNK_SHAKE", 0.5)
                SetPedAccuracy(playerPed, 40)
                isHurt = true
            end

            if hurt > 300 then
                SetTimecycleModifier("LensDistDrunk")
                Citizen.InvokeNative(0xCB9401F918CB0F75, playerPed, "mp_style_drunk", 1, -1)
                SetPedMaxMoveBlendRatio(playerPed, 0.3)
                ShakeGameplayCam("DRUNK_SHAKE", 1.0)
                SetPedConfigFlag(playerPed, 100, true)
                SetPedAccuracy(playerPed, 0)
            end
        else
            if isHurt then
                DoScreenFadeOut(500)
                Wait(500)
                DoScreenFadeIn(500)
                resetPlayerEffects()
                isHurt = false
            end
        end

        if hurt > 0 then
            hurt = hurt - 1
        end
    end
end)
