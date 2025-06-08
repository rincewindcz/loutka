local Slab = require 'editor.lib.slab'

local MenuBar = {}
MenuBar.__index = MenuBar
function MenuBar.new()
    local self = setmetatable({}, MenuBar)
    return self
end

function MenuBar:update(dt)
    if Slab.BeginMainMenuBar() then
        if Slab.BeginMenu("File") then
            if Slab.BeginMenu("New") then
                if Slab.MenuItem("File") then
                    -- Create a new file.
                end

                if Slab.MenuItem("Project") then
                    -- Create a new project.
                end

                Slab.EndMenu()
            end

            Slab.MenuItem("Open")
            Slab.MenuItem("Save")
            Slab.MenuItem("Save As")

            Slab.Separator()

            if Slab.MenuItem("Quit") then
                love.event.quit()
            end

            Slab.EndMenu()
        end

        Slab.EndMainMenuBar()
    end
end

return MenuBar