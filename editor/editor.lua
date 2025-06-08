local State = require 'editor.state'
local Slab = require 'editor.lib.slab'
local MenuBar = require 'editor.ui.menu'
local Grid = require 'editor.ui.grid'

local Editor = {}
Editor.__index = Editor
function Editor.new(args)
    local self = setmetatable({}, Editor)
    self.state = State.new()
    self.bgColor = {0.25, 0.25, 0.25, 1}
    self.menu = MenuBar.new()
    self.grid = Grid.new()
    self:init(args)
    return self
end

function Editor:init(args)
    Slab.Initialize(args)
end

function Editor:update(dt)
    --self.state:update(dt)
    Slab.Update(dt)
    self.menu:update(dt)
end

function Editor:draw()
    love.graphics.clear(self.bgColor)
    Slab.Draw()
end

return Editor