Common = {}

function Common:IsMinionValid(minion, team)
    return (minion and minion.ptr ~= 0 and minion.team == team and (not minion.isDead) and minion.isTargetable and minion.isVisible and minion.health > 0)
end

function Common:GetMinions(pos, range, team)
    local result = {}

    for i = 0, objManager.minions.size[team] - 1 do
        local minion = objManager.minions[team][i]

        if self:IsMinionValid(minion, team) and minion.pos:dist(pos) < range then
            result[#result + 1] = minion
        end
    end

    return result
end

function Common:CountMinionsInRange(pos, range, team)
    local result = 0

    for i = 0, objManager.minions.size[team] - 1 do
        local minion = objManager.minions[team][i]

        if self:IsMinionValid(minion, team) and minion.pos:dist(pos) < range then
            result = result + 1
        end
    end

    return result
end

return Common