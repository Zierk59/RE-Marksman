JungleClear = Mode:new()

-- Set mode name
JungleClear.Name = "JungleClear"

function JungleClear:Execute()
    local jinx = Controller.Champion
    local menu = Controller.Menu.LaneClear

    -- Check Q usage and mana limiter
    if not menu.UseQInJungleClear:get() or ((player.mana / player.maxMana * 100) < menu.MinManaQ:get()) then
        return
    end

    -- Get jungle monsters in AA range
    local minions = Common:GetMinions(player.pos, player.attackRange, TEAM_NEUTRAL)

    -- Check there is any monster
    if #minions <= 0 then
        return
    end

    -- Group minions
    local minionsGroups = 0

    for i = 1, #minions do
        if Common:CountMinionsInRange(minions[i].pos, 150, TEAM_NEUTRAL) > 0 then
            minionsGroups = minionsGroups + 1
        end
    end

    if jinx:HasMinigun() and #minions > 1 and minionsGroups > 1 and Controller.Orbwalker.core.can_attack() then
        jinx.SpellManager.Q:cast()
    elseif jinx:HasRocketLauncher() and Controller.Orbwalker.core.can_attack() then
        jinx.SpellManager.Q:cast()
    end
end

function JungleClear:ShouldGetExecuted()
    return Controller.Orbwalker.menu.lane_clear:get()
end

function JungleClear:Draw()
end

return JungleClear