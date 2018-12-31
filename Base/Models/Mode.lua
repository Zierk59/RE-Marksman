Mode = {}

function Mode:new(e)
    e = e or {}
    setmetatable(e, self)
    self.__index = self

    return e
end

function Mode:Initialize()
    Controller.Logger:Log("Mode." .. self.Name .. " has been added!", 0)
end

function Mode:Execute()
end

function Mode:ShouldGetExecuted()
    return false
end

function Mode:Draw()
end