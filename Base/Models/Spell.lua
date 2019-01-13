Spell = {}

function Spell:new(e)
    e = e or {}
    t = {
        slot = e.slot,
        range = e.range,
        delay = e.delay or 0.25,
        speed = e.speed or 1200,
        radius = e.radius or 0,
        width = e.width or 0,
        from = e.from or player,
        collision = e.collision or {hero = false, minion = false, wall = false},
        type = e.type or "press",
        boundingRadiusMod = e.boundingRadiusMod or 1
    }

    setmetatable(t, self)
    self.__index = self

    return t
end

function Spell:isReady()
    return self.from:spellSlot(self.slot).state == 0
end

function Spell:getPrediction(target)
    local result, castPos, hitChance
    
    if self.type == "linear" then
        result = Controller.Prediction.linear.getController.Prediction(self, target, self.from)
    elseif self.type == "circular" then
        result = Controller.Prediction.circular.getController.Prediction(self, target, self.from)
    else
        result = Controller.Prediction.core.lerp(target.path, network.latency + .25, target.moveSpeed)
    end

    if result then
        castPos = vec3(result.endPos.x, target.y, result.endPos.y)
        hitChance = 2

        if result.startPos:dist(result.endPos) > self.range then
            hitChance = 0
        end

        if self.collision and Controller.Prediction.collision.getController.Prediction(self, result, target) then
            hitChance = 0
        end
    
        local tempAngle = mathf.angle_between(result.endPos, self.from.pos:to2D(), target.pos:to2D())
        if tempAngle < 30 or tempAngle > 150 then
            hitChance = hitChance + 1
        else
            hitChance = hitChance / 2
        end
    end

    return result, castPos, hitChance      
end

function Spell:cast(castOn, castOn2)
    if not self:isReady() then 
        return 
    end

    if self.type == "press" or not castOn then
        return player:castSpell("self", self.slot)
    end

    local isObj = not (castOn.type == vec3.type or castOn.type == vec2.type)  
    if castOn2 and not isObj then
        player:castSpell("line", self.slot, castOn, castOn2)
    end                        
    return player:castSpell((isObj and "obj") or "pos", self.slot, castOn)
end

function Spell:castToPred(target, minHitChance)
    if not target then return end
    
    local result, predPos, hitChance = self:getPrediction(target)

    if predPos and hitChance >= minHitChance then                         
        return self:cast(predPos)            
    end
end

function Spell:getInstance()
    return player:spellSlot(self.slot)
end