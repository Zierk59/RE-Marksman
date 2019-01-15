local Jinx = Champion:new()

function Jinx:Initialize()
    -- Load menu
    -- Combo settings
    Controller.Menu:menu("Combo", "Combo")

    Controller.Menu.Combo:header("", "Switcheroo! (Q) settings :")
    Controller.Menu.Combo:boolean("UseQ", "Use Q", true)

    Controller.Menu.Combo:header("", "Zap! (W) settings :")
    Controller.Menu.Combo:boolean("UseW", "Use W", true)
    Controller.Menu.Combo:slider("WMinDistanceToTarget", "Minimum distance to target to cast", 800, 0, 1500, 50)
    Controller.Menu.Combo.WMinDistanceToTarget:set("tooltip", "Cast W only if distance from player to target is higher than desired value.")

    Controller.Menu.Combo:header("", "Flame Chompers! (E) settings :")
    Controller.Menu.Combo:boolean("UseE", "Use E", true)
    Controller.Menu.Combo:boolean("AutoE", "Automated E usage on certain spells", true)
    Controller.Menu.Combo.AutoE:set("tooltip", "Automated E usage fires traps on enemy champions that are Teleporting or are in Zhonyas. It also searchs for spells with long cast time like Caitlyn's R or Malzahar's R")

    Controller.Menu.Combo:header("", "Super Mega Death Rocket! (R) settings :")
    Controller.Menu.Combo:boolean("UseR", "Use R", true)
    Controller.Menu.Combo:keybind("RKeybind", "R keybind", 'T', false)
    Controller.Menu.Combo:slider("RRangeKeybind", "Maximum range to enemy to cast R while keybind is active", 1100, 300, 5000, 100)

    -- Harass settings
    Controller.Menu:menu("Harass", "Harass")

    Controller.Menu.Harass:header("", "Switcheroo! (Q) settings :")
    Controller.Menu.Harass:boolean("UseQ", "Use Q", true)
    Controller.Menu.Combo:slider("MinManaQ", "Minimum mana percentage to use Q", 80, 1, 100, 1)

    Controller.Menu.Harass:header("", "Zap! (W) settings :")
    Controller.Menu.Harass:boolean("UseW", "Auto harass with W", true)
    Controller.Menu.Harass.UseW:set("tooltip", "Enables auto harass on enemy champions.")
    Controller.Menu.Harass:slider("MinManaW", "Minimum mana percentage to use W", 50, 1, 100, 1)
    Controller.Menu.Harass:menu("Champions", "W harass enabled for :")

    for i = 0, objManager.enemies_n -1 do
        local unit = objManager.enemies[i]

        if unit then
            Controller.Menu.Harass.Champions:boolean(unit.charName, unit.charName, true)
        end
    end

    -- Lane Clear settings
    Controller.Menu:menu("LaneClear", "Lane Clear")

    Controller.Menu.LaneClear:header("", "Basic settings :")
    Controller.Menu.LaneClear:boolean("EnableIfNoEnemies", "Enable lane clear only if no enemies nearby", true)
    Controller.Menu.LaneClear:slider("ScanRange", "Range to scan for enemies", 1500, 300, 2500, 50)
    Controller.Menu.LaneClear:slider("AllowedEnemies", "Allowed enemies amount", 1, 0, 5, 1)

    Controller.Menu.LaneClear:header("", "Switcheroo! (Q) settings :")
    Controller.Menu.LaneClear:boolean("UseQInLaneClear", "Use Q in Lane Clear", true)
    Controller.Menu.LaneClear:boolean("UseQInJungleClear", "Use Q in Jungle Clear", true)
    Controller.Menu.LaneClear:slider("MinManaQ", "Minimum mana percentage to use Q", 50, 1, 100, 1)

    -- Misc
    Controller.Menu:menu("Misc", "Misc")

    Controller.Menu.Misc:header("", "Basic settings :")
    Controller.Menu.Misc:boolean("EnableInterrupter", "Cast E against interruptible spells", false)
    Controller.Menu.Misc:boolean("EnableAntiGapcloser", "Cast E against gapclosers", true)
    Controller.Menu.Misc:boolean("WKillsteal", "Cast W to killsteal", true)
    Controller.Menu.Misc:boolean("RKillsteal", "Cast R to killsteal", true)
    Controller.Menu.Misc:slider("RKillstealMaxRange", "Maximum range to enemy to cast R for killsteal", 2000, 0, 20000, 100)

    -- Drawings
    Controller.Menu:menu("Drawings", "Drawings")

    Controller.Menu.Drawings:header("", "Basic settings :")
    Controller.Menu.Drawings:boolean("DrawSpellRangesWhenReady", "Draw spell ranges only when they are ready", true)

    Controller.Menu.Drawings:header("", "Switcheroo! (Q) drawing settings :")
    Controller.Menu.Drawings:boolean("DrawRocketsRange", "Draw Q rockets range", true)
    Controller.Menu.Drawings:color("DrawRocketsRangeColor", "Change color", 0, 255, 191, 255)

    Controller.Menu.Drawings:header("", "Switcheroo! (Q) drawing settings :")
    Controller.Menu.Drawings:boolean("DrawW", "Draw W range", true)
    Controller.Menu.Drawings:color("DrawWColor", "Change color", 0, 158, 96, 255)

    Controller.Logger:Log("Champion.Jinx loaded.")
end

function Jinx.SpellManager:Initialize()
    Jinx.SpellManager.Q = Spell:new({
        slot = 0,
        range = 0,
        delay = 0.25,
        speed = 0,
        radius = 0,
        collision = false,
        type = "press"
    })

    Jinx.SpellManager.W = Spell:new({
        slot = 1,
        range = 1450,
        delay = 0.6,
        speed = 3200,
        width = 60,
        collision = {
            hero = true,
            minion = true,
            wall = false
        },

        type = "linear",
        boundingRadiusMod = 0
    })

    Jinx.SpellManager.E = Spell:new({
        slot = 2,
        range = 900,
        radius = 100,
        delay = 0.9,
        speed = 5000,
        width = 100,
        collision = {
            hero = true,
            minion = false,
            wall = false
        },

        type = "circular",
        boundingRadiusMod = 1
    })

    Jinx.SpellManager.R = Spell:new({
        slot = 3,
        range = 30000,
        delay = 0.6,
        speed = 1500,
        width = 140,
        collision = {
            hero = true,
            minion = false,
            wall = false
        },

        type = "linear",
        boundingRadiusMod = 0
    })
end

function Jinx:GetFirecanonStacks()
    if not self:HasItemFirecanon() then
        return 0
    end

    for i = 0, player.buffManager.count - 1 do
        local buff = player.buffManager:get(i)
        if buff and buff.valid and buff.name == 'itemstatikshankcharge' then
            return math.max(buff.stacks, buff.stacks2)
        end
    end

    return 0
end

function Jinx:HasFirecanonStackedUp()
    return self:GetFirecanonStacks() == 100
end

function Jinx:HasItemFirecanon()
    return Common:HasItem(player, Common.Items.Rapid_Firecannon)
end

function Jinx:HasMinigun()
    return Common:HasBuff(player, "jinxqicon")
end

function Jinx:GetMinigunStacks()
    for i = 0, player.buffManager.count - 1 do
        local buff = player.buffManager:get(i)
        
        if buff and buff.valid and buff.name == 'jinxqramp' then
            return math.max(buff.stacks, buff.stacks2)
        end
    end

    return 0
end

function Jinx:HasRocketLauncher()
    return self:HasMinigun() == false
end

function Jinx:GetRealRocketLauncherRange()
    local qRange = 700 + 25 * (self.SpellManager.Q:getInstance().level - 1)
    local additionalRange = 0

    if self:HasFirecanonStackedUp() then
        additionalRange = math.min(qRange * 0.35, 150)
    end
    
    return (qRange + additionalRange)
end

function Jinx:GetRealMinigunRange()
    if self:HasFirecanonStackedUp() then
        return math.min(525 * 1.35, 525 + 150)
    end

    return 525
end

return Jinx