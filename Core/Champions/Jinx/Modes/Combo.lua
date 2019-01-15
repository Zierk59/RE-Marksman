local Combo = Mode:new()

-- Set Combo name
Combo.Name = "Combo"

function Combo:Execute()
    local jinx = Controller.Champion
    local menu = Controller.Menu.Combo
    
    -- Q logic
    if jinx.SpellManager.Q:isReady() and menu.UseQ:get() and Controller.Orbwalker.core.can_attack() then
        local target = Common:GetTarget(jinx:GetRealRocketLauncherRange())

        if target and target ~= nil and Common:IsValidTarget(target) then
            if Common:IsInRange(player, target, jinx:GetRealMinigunRange()) and jinx:HasRocketLauncher() and (Common:GetTotalHealthWithShields(target) > (Common:GetAutoAttackDamage(target) * 2.2)) then
                jinx.SpellManager.Q:cast()
                return
            end

            if (not Common:IsInRange(player, target, jinx:GetRealMinigunRange())) and Common:IsInRange(player, target, jinx:GetRealRocketLauncherRange()) and (not jinx:HasRocketLauncher()) then
                jinx.SpellManager.Q:cast()
                return
            end

            if jinx:HasMinigun() and (jinx:GetMinigunStacks() >= 2) and (Common:GetTotalHealthWithShields(target) < (Common:GetAutoAttackDamage(target) * 2.2)) and (Common:GetTotalHealthWithShields(target) > (Common:GetAutoAttackDamage(target) * 2)) then
                jinx.SpellManager.Q:cast()
                return
            end
        end
    end

    -- W logic
    if jinx.SpellManager.W:isReady() and menu.UseW:get() then
        if (Common:CountEnemiesInRange(menu.WMinDistanceToTarget:get()) == 0) and (not Common:IsPosUnderEnemyTurret(player.pos)) and ((player.mana - (50 + 10 * (jinx.SpellManager.W:getInstance().level - 1))) > ((jinx.SpellManager.R:isReady() == true) and 100 or 50)) then
            local target = Common:GetTarget(jinx.SpellManager.W.range)

            if target and target ~= nil and Common:IsValidTarget(target) then
                jinx.SpellManager.W:castToPred(target, Common.HitChance.Medium)
                return
            end
        end
    end

    -- E logic
    if jinx.SpellManager.E:isReady() and menu.UseE:get() then
        if (player.mana - 50 > 100) then
            local target = Common:GetTarget(jinx.SpellManager.E.range)

            if target and target ~= nil and Common:IsValidTarget(target) then
                local result, predPos, hitChance = jinx.SpellManager.E:getPrediction(target)

                if ((hitChance >= Common.HitChance.High) and (predPos:dist(target.pos) > 150)) or ((hitChance >= Common.HitChance.Medium) and (predPos:dist(target.pos) > 150) and Common:IsMovingTowards(target, 500)) then
                    jinx.SpellManager.E:cast(predPos)
                    return
                end
            end
        end
    end
end

function Combo:ShouldGetExecuted()
    return Controller.Orbwalker.menu.combat:get()
end

function Combo:Draw()
end

return Combo