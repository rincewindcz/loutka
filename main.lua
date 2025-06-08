local Editor = require 'editor.editor'

local Images = {
    load = function(t, name)
        t[name] = love.graphics.newImage('assets/' .. name .. '.png') 
    end
}

local editor

function love.load(args)
    love.window.setMode(1600, 900, { fullscreen = false })
    editor = Editor.new(args)
end

function love.update(dt)
    editor:update(dt)
end

function love.draw()
    editor:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' or key == 'q' then
        love.event.quit()
    elseif key == 'space' then
        print('space')
    end
end
