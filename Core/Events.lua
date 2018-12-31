local Events = {}

function Events:OnTick()
    if player.isDead or player.isRecalling then
        return
    end

    for _, e in pairs(Controller.Champion.Modes) do
        if e.ShouldGetExecuted() then
            e.Execute()
        end
    end
end

function Events:OnDraw()
    if player.isDead then
        return
    end

    for _, e in pairs(Controller.Champion.Modes) do
        e.Draw()
    end
end

function Events:OnIssueOrder()
end

return Events