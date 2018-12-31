local SpellManager = {}

-- Initialize all spells
SpellManager.Q = nil
SpellManager.W = nil
SpellManager.E = nil
SpellManager.R = nil

function SpellManager:Initialize()
    Controller.Logger:Log("SpellManager:Initialize is not set in module.", 1)
end

return SpellManager