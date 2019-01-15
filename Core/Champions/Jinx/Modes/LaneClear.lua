LaneClear = Mode:new()

-- Set mode name
LaneClear.Name = "LaneClear"

function LaneClear:CanILaneClear()
    local jinx = Controller.Champion
    local menu = Controller.Menu.LaneClear

    return ((not menu.EnableIfNoEnemies:get()) or (Common:CountEnemiesInRange(menu.ScanRange:get()) <= menu.AllowedEnemies:get()))
end

function LaneClear:Execute()
    local jinx = Controller.Champion
    local menu = Controller.Menu.LaneClear

    if (not menu.UseQInLaneClear:get()) or Common:IsPosUnderEnemyTurret(player.pos) then
        return
    end

    local laneMinions = Common:GetMinions(player.pos, jinx:GetRealRocketLauncherRange() + 100, TEAM_ENEMY)
    if not laneMinions or #laneMinions <= 0 then
        return
    end

    local rocketsLanuncherMinions = {}
    for i = 1, #laneMinions do
        local minion = laneMinions[i]

        if Common:IsInRange(player, minion, jinx:GetRealRocketLauncherRange()) then
            local count = 0

            for c = 1, #laneMinions do
                local cmpMinion = laneMinions[c]

                if i ~= c then
                    if (cmpMinion.pos:dist(minion.pos) <= 150) and (Controller.Orbwalker.farm.predict_hp(cmpMinion, 350) < Common:GetAutoAttackDamage(cmpMinion) * 1.1) then
                        count = count + 1
                    end
                end
            end

            if count > 3 or ((player.pos:dist(minion.pos) > jinx:GetRealMinigunRange()) and (Controller.Orbwalker.farm.predict_hp(minion, 350) < Common:GetAutoAttackDamage(minion) * 0.95)) then
                rocketsLanuncherMinions[#rocketsLanuncherMinions + 1] = minion
            end
        end
    end

    if jinx:HasMinigun() then
        if (#rocketsLanuncherMinions <= 0) or (not LaneClear:CanILaneClear()) or ((player.mana / player.maxMana * 100) < menu.MinManaQ:get()) or (not Controller.Orbwalker.core.can_attack()) then
            return
        end

        jinx.SpellManager.Q:cast()
    elseif (jinx:HasRocketLauncher() and (#rocketsLanuncherMinions <= 0)) then
        if Controller.Orbwalker.core.can_attack() then
            jinx.SpellManager.Q:cast()
        end
    end
end

function LaneClear:ShouldGetExecuted()
    return Controller.Orbwalker.menu.lane_clear:get()
end

function LaneClear:Draw()
end

return LaneClear