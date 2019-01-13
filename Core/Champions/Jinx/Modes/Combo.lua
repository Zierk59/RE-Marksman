local Combo = Mode:new()

-- Set Combo name
Combo.Name = "Combo"

function Combo:Execute()
    local jinx = Controller.Champion
end

function Combo:ShouldGetExecuted()
    return Controller.Orbwalker.menu.combat:get()
end

function Combo:Draw()
end

return Combo