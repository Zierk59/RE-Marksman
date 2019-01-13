Harass = Mode:new()

-- Set mode name
Harass.Name = "Harass"

function Harass:Execute()
    Controller.Logger:Log('Harass:Execute()')
end

function Harass:ShouldGetExecuted()
    return Controller.Orbwalker.menu.hybrid:get()
end

function Harass:Draw()
end

return Harass