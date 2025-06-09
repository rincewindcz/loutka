local Renderer = {}
Renderer.__index = Renderer
function Renderer.new(state)
    local self = setmetatable({}, Renderer)
    self.state = state
    return self
end

function Renderer:drawGhosts()
    if self.state.placing_part then
        local x, y = self.state:toScenePosition(love.mouse.getX(), love.mouse.getY())
        self.state.placing_part:draw(x, y)
    end
end

function Renderer:origin()
    local w, h = love.graphics.getDimensions()
    love.graphics.setColor(1, 1, 1, 1.0/5)
    love.graphics.setLineWidth(2)
    love.graphics.line(-w, 0, w, 0)
    love.graphics.line(0, -h, 0, h)

    love.graphics.setLineWidth(1)
end

function Renderer:drawPart(part, selected)
    love.graphics.setColor(part.color[1], part.color[2], part.color[3], part.color[4])
    love.graphics.draw(part.image, part.x, part.y, part.angle, part.scale, part.scale, part.values.ox, part.values.oy)

    if selected then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setLineWidth(2)

        love.graphics.rectangle('line', part.x - part.values.ox, part.y - part.values.oy, part.image:getWidth(), part.image:getHeight())
    end
end

function Renderer:drawActor(actor)
    love.graphics.push()
    love.graphics.translate(actor.x, actor.y)
    love.graphics.rotate(actor.angle)
    love.graphics.scale(actor.scale, actor.scale)
    for _, part in ipairs(actor.parts) do
        self:drawPart(part, self.state:isSelected(part))
    end
    love.graphics.pop()
end

function Renderer:drawStats()
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 20)
    local x, y = self.state:toScenePosition(love.mouse.getX(), love.mouse.getY())
    love.graphics.print('X: ' .. x.. ' Y: ' .. y, 10, 40)
end

function Renderer:draw()
    self:origin()
    
    self:drawActor(self.state.actor)
end

return Renderer