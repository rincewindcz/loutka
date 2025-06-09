local Slab = require 'editor.lib.slab'
local Loutka = require 'lib.loutka'
local Part = Loutka.Part

local MenuBar = {}
MenuBar.__index = MenuBar
function MenuBar.new(state)
    local self = setmetatable({}, MenuBar)
    self.state = state
    return self
end

function MenuBar:fileMenu()
    if Slab.BeginMenu("File") then
        if Slab.MenuItem("New") then
            self.state:reset()
        end

        if Slab.MenuItem("Open") then
            self.state:open()
        end

        if Slab.MenuItem("Save") then
            self.state:save()
        end

        if Slab.MenuItem("Save as") then
            self.state:saveAs()
        end

        Slab.Separator()
        if Slab.MenuItem("Exit") then
            love.event.quit()
        end

        Slab.EndMenu()
    end
end

function MenuBar:editMenu()
    if Slab.BeginMenu("Edit") then
        if Slab.MenuItem("Undo") then
            self.state:undo()
        end

        if Slab.MenuItem("Redo") then
            self.state:redo()
        end

        Slab.Separator()
        if Slab.MenuItem("Cut") then
            self.state:cut()
        end

        if Slab.MenuItem("Copy") then
            self.state:copy()
        end

        if Slab.MenuItem("Paste") then
            self.state:paste()
        end

        Slab.EndMenu()
    end
end

function MenuBar:assetsMenu()
    if Slab.BeginMenu("Assets") then
        if Slab.MenuItem("Add folder") then

        end

        if Slab.MenuItem("Add image") then

        end

        Slab.EndMenu()
    end
end

function MenuBar:partsMenu()
    if Slab.BeginMenu("Parts") then
        if self.state.assets.count > 1 then
            for name, asset in pairs(self.state.assets.images) do
                if Slab.MenuItem(name) then
                    --self.state:addAsset(asset)
                    local x, y = self.state:toScenePosition(Slab.GetMousePosition())
                    print("add asset", name, x, y)
                    local part = Part.new(asset, x, y)
                    part.color = { 1, 0.2, 0.5, 0.15 }
                    self.state:setStatePlacing(part)
                end
            end
        end
        
        Slab.EndMenu()
    end
end

function MenuBar:movementMenu()
    if Slab.BeginMenu("Movement") then
        if Slab.MenuItem("Move") then

        end

        if Slab.MenuItem("Rotate") then

        end

        if Slab.MenuItem("Scale") then

        end
        Slab.EndMenu()
    end
end

function MenuBar:selectionMenu()
    if Slab.BeginMenu("Selection") then

        if Slab.BeginMenu("Select") then
            for _, part in ipairs(self.state.actor.parts) do
                local name = part.name or '(unnamed)'
                if Slab.MenuItemChecked(name, self.state:isSelected(part)) then
                    self.state:select({ part })
                end
            end
            Slab.EndMenu()
        end
        if Slab.MenuItem("Select all") then
            self.state:select(self.state.actor.parts)
        end

        if Slab.MenuItem("Invert") then
            local new_selection = {}

            for _, part in ipairs(self.state.actor.parts) do
                if not self.state:isSelected(part) then
                    table.insert(new_selection, part)
                end
            end
            self.state:select(new_selection)
        end

        if Slab.MenuItem("Deselect") then
            self.state:select({})
        end

        if #self.state.selection > 0 then
            Slab.Separator()
            if Slab.MenuItem("Delete") then
                print('TODO: delete')
            end
        end

        Slab.EndMenu()
    end
end

function MenuBar:helpMenu()
    if Slab.BeginMenu("Help") then
        if Slab.MenuItem("About") then
            Slab.OpenDialog("about")
        end

        Slab.EndMenu()
    end
end


function MenuBar:update(dt)
    if Slab.BeginMainMenuBar() then
        self:fileMenu()
        self:editMenu()
        self:assetsMenu()
        self:partsMenu()
        self:movementMenu()
        self:selectionMenu()
        self:helpMenu()
        Slab.EndMainMenuBar()
    end
end

return MenuBar