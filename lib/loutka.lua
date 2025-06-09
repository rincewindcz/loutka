-- animation.lua
local Actor = {}
Actor.__index = Actor

local Part = {}
Part.__index = Part

local Motion = {}
Motion.__index = Motion

local Amount = {}
Amount.__index = Amount

local Script = {}
Script.__index = Script

function Amount.Move(x, y)
    return { x = x, y = y, type = 'move' }
end

function Amount.Rotate(angle)
    return { angle = angle, type = 'rotate' }
end

function Amount.Scale(scale)
    return { scale = scale, type = 'scale' }
end

-- ==== PART ====

function Part.new(image, x, y, angle, scale, originX, originY)
    local self = setmetatable({}, Part)
    self.image = image
    self.x = x or 0
    self.y = y or 0
    self.angle = angle or 0
    self.scale = scale or 1
    self.originX = originX or 0.5
    self.originY = originY or 0.5
    self.multiplier = 1
    self.color = {1, 1, 1, 1}
    self.name = nil

    self.values = {
        x = 0,
        y = 0,
        angle = 0,
        scale = self.scale,
        ox = self.image:getWidth() * self.originX,
        oy = self.image:getHeight() * self.originY
    }
    return self
end

function Part:draw()
    local x = self.x + self.values.x
    local y = self.y + self.values.y
    local angle = self.angle + self.values.angle
    local scale = self.scale * self.values.scale

    love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
    love.graphics.draw(self.image, x, y, angle, scale, scale, self.values.ox, self.values.oy)
end

-- ==== MOTION ====

function Motion.new(amount, parts, duration, repeat_count)
    local self = setmetatable({}, Motion)
    self.amount = amount
    self.parts = parts or {}
    self.duration = duration or 1
    self.repeat_count = repeat_count or -1
    self.enabled = true

    self.status = {
        current = self.repeat_count,
        elapsed = 0,
        direction = 1
    }

    self.values = {
        x = 0,
        y = 0,
        angle = 0,
        scale = 0
    }
    return self
end

function Motion:update(dt)
    if not self.enabled then return end

    self.status.elapsed = self.status.elapsed + dt * self.status.direction

    if self.status.elapsed >= self.duration then
        self.status.elapsed = self.duration
        self.status.direction = -1
    elseif self.status.elapsed <= 0 then
        self.status.elapsed = 0
        self.status.direction = 1

        if self.status.current == 0 then
            self.enabled = false
            return
        elseif self.status.current > 0 then
            self.status.current = self.status.current - 1
        end
    end

    local ratio = self.status.elapsed / self.duration

    if self.amount.type == 'move' then
        self.values.x = self.amount.x * ratio
        self.values.y = self.amount.y * ratio
    elseif self.amount.type == 'rotate' then
        self.values.angle = self.amount.angle * ratio
    elseif self.amount.type == 'scale' then
        self.values.scale = self.amount.scale * ratio
    end

    for _, part in ipairs(self.parts) do
        part.values.x = part.x + self.values.x * part.multiplier
        part.values.y = part.y + self.values.y * part.multiplier
        part.values.angle = part.angle + self.values.angle * part.multiplier
        part.values.scale = part.scale + self.values.scale * part.multiplier
    end
end

function Motion:play(repeat_count)
    self.enabled = true
    self.status.current = repeat_count or self.repeat_count
    self.status.elapsed = 0
    self.status.direction = 1
    self.values = {
        x = 0,
        y = 0,
        angle = 0,
        scale = 0
    }
end

-- ==== ANIMATION ====

function Actor.new(x, y, angle, scale)
    local self = setmetatable({}, Actor)
    self.x = x or 0
    self.y = y or 0
    self.angle = angle or 0
    self.scale = scale or 1
    self.parts = {}
    self.scripts = {}
    self._current_script = nil
    return self
end

function Actor:addParts(...)
    for _, part in ipairs({...}) do
        table.insert(self.parts, part)
    end
end

function Actor:addScript(script)
    self.scripts[script.name] = script
    self._current_script = script
end

function Actor:playScript(name)
    self._current_script = self.scripts[name]
end

-- draw all parts with correct rotation
function Actor:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.angle)
    love.graphics.scale(self.scale, self.scale)
    for _, part in ipairs(self.parts) do
        part:draw()
    end
    love.graphics.pop()
end

function Actor:update(dt)
    if self._current_script then
        self._current_script:update(dt)
    end
end

-- Script
function Script.new(name)
    local self = setmetatable({}, Script)
    self.name = name
    self.motions = {}
    return self
end

function Script:addMotion(motion)
    table.insert(self.motions, motion)
end

function Script:update(dt)
    for _, motion in ipairs(self.motions) do
        motion:update(dt)
    end
end

-- Return all classes
return {
    Actor = Actor,
    Part = Part,
    Motion = Motion,
    Amount = Amount,
    Script = Script
}
