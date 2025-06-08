local Loutka = require 'lib.loutka'
local Amount = Loutka.Amount
local Actor = Loutka.Actor
local Part = Loutka.Part
local Motion = Loutka.Motion
local Script = Loutka.Script

local Images = {
    load = function(t, name)
        t[name] = love.graphics.newImage('assets/' .. name .. '.png')
    end
}

local anim
local angle = 0

function love.load()
    love.window.setMode(1600, 900, { fullscreen = false })
    Images:load('head')
    Images:load('body')
    Images:load('limb')

    anim = Actor.new(500, 500)
    local b = Part.new(Images.body)
    local h = Part.new(Images.head, 0, -50)
    local lr = Part.new(Images.limb, 5, -20, 0, 1, 0, 0.5)
    local ll = Part.new(Images.limb, -5, -20, 0, 1, 1, 0.5)
    ll.multiplier = -1

    h.color = { 1, 0.8, 0.8, 1 }
    anim:addParts(b, h, lr, ll)

    local m1 = Motion.new(Amount.Scale(0.05), { b, h }, 0.5)
    --anim:addMotion(m1)
    local s = Script.new('default')
    s:addMotion(m1)

    local m2 = Motion.new(Amount.Rotate(math.rad(20)), { lr, ll }, 1)
    s:addMotion(m2)

    local m3 = Motion.new(Amount.Move(5, 0), { b, h, lr, ll }, 0.25)
    s:addMotion(m3)

    anim:addScript(s)
end

function love.update(dt)
    anim:update(dt)
    angle = angle + 0.5 * dt
    anim.angle = angle
end

function love.draw()
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
    love.graphics.print('Mouse: ' .. love.mouse.getX() .. ' ' .. love.mouse.getY(), 10, 30)

    anim:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
