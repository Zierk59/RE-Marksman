Champion = {}

-- Modes
Champion.Modes = {}

-- Damage manager
Champion.DamageManager = nil

-- Spell manager
Champion.SpellManager = nil

function Champion:new(e)
    e = e or {}
    setmetatable(e, self)
    self.__index = self

    return e
end

-- Don't override it!
function Champion:Bootstrap()
    -- Valid modes
    local allModes = {'Combo', 'Harass', 'JungleClear', 'LaneClear', 'LastHit', 'PermaActive'}

    -- Load all modes
    for _, e in ipairs(allModes) do
        local mode = module.load ('Core/Champions/' .. tostring(Controller.Champion) .. '/Modes/' .. e)

        if mode ~= nil then
            self:RegisterMode(mode)
            mode:Initialize()
        end
    end

    -- Load spell manager
    self.SpellManager = module.load ('Base/SpellManager')
end

function Champion:Initialize()
    Controller.Logger:Log("Champion:Initialize is not set in module.", 1)
end

function Champion:RegisterMode(mode)
    self.Modes[mode.Name] = mode
end