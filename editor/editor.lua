local State = require 'editor.state'
local Slab = require 'editor.lib.slab'
local Camera = require 'editor.lib.camera'
local MenuBar = require 'editor.ui.menu'
local AddMenu = require 'editor.ui.add-menu'
local Grid = require 'editor.ui.grid'
local Renderer = require 'editor.renderer'

local Editor = {}
Editor.__index = Editor
function Editor.new(args)
    local self = setmetatable({}, Editor)
    self.state = State.new()
    self.bgColor = {0.25, 0.25, 0.25, 1}
    self.menu = MenuBar.new(self.state)
    self.addMenu = AddMenu.new(self.state)
    self.grid = Grid.new()
    self.camera = Camera.new(0, 0)
    self.renderer = Renderer.new(self.state)

    self.__place_click = false

    self:init(args)
    return self
end

function Editor:init(args)
    Slab.Initialize(args)
    self.state.editor = self
end

function Editor:update(dt)
    self.camera:update(dt)
    Slab.Update(dt)
    self.menu:update(dt)
    self.addMenu:update(dt)
end

function Editor:draw()
    love.graphics.clear(self.bgColor)
    self.renderer:drawStats()

    self.camera:attach()
    self.renderer:draw()
    self.renderer:drawGhosts()
    self.camera:detach()
    
    Slab.Draw()
end

function Editor:onMousePressed(x, y, button, is_touch, presses)
    if self.state.placing_part and Slab.IsVoidHovered() then
        local wx, wy = self.state:toScenePosition(x, y)
        self.state.placing_part.color = { 1, 1, 1, 1 }
        self.state.placing_part.x = wx
        self.state.placing_part.y = wy
        self.state.actor:addParts(self.state.placing_part)
        self.state:resetState()
    end
end

function Editor:onMouseReleased(x, y, button, is_touch, presses)
    
end

function Editor:onMouseMoved(x, y, dx, dy, is_touch)
    if self.state.placing_part then
        local wx, wy = self.state:toScenePosition(x, y)
        self.state.placing_part.x = wx
        self.state.placing_part.y = wy
    end
end

return Editor