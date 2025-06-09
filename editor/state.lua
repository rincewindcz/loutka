local Assets = require 'editor.assets'
local Loutka = require 'lib.loutka'
local Geometry = require 'editor.util.geometry'


local State = {}
State.__index = State

State.Status = {
    IDLE = 1,
    PLACING_PART = 2
}

function State.new()
    local self = setmetatable({}, State)
    self.assets = Assets.new()
    self.motions = {}
    self.actor = Loutka.Actor.new()
    self.editor = {}
    self.selection = {}
    self.__map_selection = {}
    self.status = State.Status.IDLE

    self.placing_part = nil

    return self
end

function State:toScenePosition(x, y)
    return self.editor.camera:toWorldCoords(x, y)
end

function State:setStatePlacing(part)
    self.status = State.Status.PLACING_PART
    self.placing_part = part
end

function State:resetState()
    self.status = State.Status.IDLE
    self.placing_part = nil
end

function State:select(parts)
    self.selection = parts
    self.__map_selection = {}
    for _, part in ipairs(parts) do
        self.__map_selection[part] = true
    end
end

function State:isSelected(part)
    return self.__map_selection[part] == true
end

return State