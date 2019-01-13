PermaActive = Mode:new()

-- Set mode name
PermaActive.Name = "PermaActive"

function PermaActive:Execute()
end

function PermaActive:ShouldGetExecuted()
    return true
end

function PermaActive:Draw()
end

return PermaActive