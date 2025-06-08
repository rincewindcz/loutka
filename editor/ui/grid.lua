local Grid = {}
Grid.__index = Grid
function Grid.new()
    local self = setmetatable({}, Grid)
    self.size = 32
    self.color = {1, 1, 1, 0.25}
    return self
end

function Grid:draw()

end

return Grid