LaneClear = Mode:new()

-- Set mode name
LaneClear.Name = "LaneClear"

function LaneClear:Execute()
end

function LaneClear:ShouldGetExecuted()
    return Controller.Orbwalker.menu.lane_clear:get()
end

function LaneClear:Draw()
end

return LaneClear