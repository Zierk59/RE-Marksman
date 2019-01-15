Controller = {}

-- Current script version
Controller._VERSION = "0.1.123018"

-- Debug mode
Controller._DEBUG = true

-- Get character name to script path entity
Controller.Champion = ""

-- Get orbwalker instance
Controller.Orbwalker = nil

-- Get target selector instance
Controller.TargetSelector = nil

-- Get prediction instance
Controller.Prediction = nil

-- Events module
Controller.Events = nil

-- Script valid champions
Controller.ValidChampions = {
    "Jinx"
}

-- Script extensions
Controller.Extensions = {
    "Lua"
}

function Controller:Initialize()
    -- Load base
    module.load ('REMarksman', 'Base/Models/Champion')
    module.load ('REMarksman', 'Base/Models/Mode')
    module.load ('REMarksman', 'Base/Models/Spell')

    -- Load common
    module.load ('REMarksman', 'Extensions/Common')

    -- Load logger
    Controller.Logger = module.load ('REMarksman', 'Base/Logger')

    -- Load all extensions
    for i, e in ipairs(Controller.Extensions) do
		module.load ('REMarksman', 'Extensions/' .. e .. 'Extensions')
    end

    -- Load name
    Controller.Champion = string_first_to_upper(player.charName)

    -- Load menu
    Controller.Menu = menu("REMarksman", "RE:Marksman")
    
    -- Load champion
    if array_has_value(Controller.ValidChampions, Controller.Champion) then
        Controller.Champion = module.load ('REMarksman', 'Core/Champions/' .. Controller.Champion .. '/' .. Controller.Champion)

        -- Load menu header
        Controller.Menu:header("", ("RE:" .. player.charName))

        -- Load base modules
        Controller.Prediction = module.internal('pred')
        Controller.Orbwalker = module.internal('orb')
        Controller.TargetSelector = module.internal('TS')

        -- Load champion module
        Controller.Champion:Bootstrap()
        Controller.Champion:Initialize()

        -- Load spell manager
        Controller.Champion.SpellManager:Initialize()

        -- Load events
        Controller.Events = module.load ('REMarksman', 'Core/Events')

        -- Trigger events
        cb.add(cb.tick, Controller.Events.OnTick)
        cb.add(cb.draw, Controller.Events.OnDraw)
        cb.add(cb.issueorder, Controller.Events.OnIssueOrder)
    else
        Controller.Logger:Log('Character not found.', 1)
    end

    Controller.Logger:Log('RE:Marksman v.' .. Controller._VERSION .. ' initialized!')
end

Controller:Initialize()