local Slab = require 'editor.lib.slab'
local Loutka = require 'lib.loutka'
local Part = Loutka.Part

local AddMenu = {}
AddMenu.__index = AddMenu
function AddMenu.new(state)
    local self = setmetatable({}, AddMenu)
    self.state = state
    return self
end

function AddMenu:empty()
    if Slab.BeginContextMenuWindow() then
        Slab.MenuItem(" ")
        Slab.MenuItem("< empty -- add some assets >")
        Slab.MenuItem(" ")
        Slab.EndContextMenu()
    end
end

function AddMenu:assets()
    if Slab.BeginContextMenuWindow() then
        for name, asset in pairs(self.state.assets.images) do
            if Slab.MenuItem(name) then
                --self.state:addAsset(asset)
                local x, y = self.state:toScenePosition(Slab.GetMousePosition())
                print("add asset", name, x, y)
                local part = Part.new(asset, x, y)
                part.color = {1, 0.2, 0.5, 0.15}
                self.state:setStatePlacing(part)
            end
        end
        Slab.EndContextMenu()
    end
end

function AddMenu:update(dt)
    if self.state.assets.count > 0 then
        self:assets()
    else
        self:empty()
    end
end


return AddMenu