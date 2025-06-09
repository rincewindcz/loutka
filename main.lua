local Editor = require 'editor.editor'
local Loutka = require 'lib.loutka'

local editor

---@diagnostic disable-next-line: duplicate-set-field
function love.load(args)
    love.window.setMode(1600, 900, { fullscreen = false })
    editor = Editor.new(args)
    editor.state.assets:addFolder('assets')
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
    editor:update(dt)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
    editor:draw()
end

---@diagnostic disable-next-line: duplicate-set-field
function love.keypressed(key, scan_code, is_repeat)
    if key == 'escape' or key == 'q' then
        love.event.quit()
    elseif key == 'space' then
        print('space')
    end
end

function love.wheelmoved(x, y)
    editor:wheelmoved(x, y)
end

function love.mousemoved(x, y, dx, dy, is_touch)
    editor:onMouseMoved(x, y, dx, dy, is_touch)
end

function love.mousereleased(x, y, button, is_touch, presses)
    editor:onMouseReleased(x, y, button, is_touch, presses)
end

function love.mousepressed(x, y, button, is_touch, presses)
    editor:onMousePressed(x, y, button, is_touch, presses)
end
