LastHit = Mode:new()

-- Set mode name
LastHit.Name = "LastHit"

function LastHit:Execute()
    Controller.Logger:Log('LastHit:Execute()')
end

function LastHit:ShouldGetExecuted()
    return Controller.Orbwalker.menu.last_hit:get()
end

function LastHit:Draw()
end

return LastHit