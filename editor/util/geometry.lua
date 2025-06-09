local Geometry = {}
Geometry.__index = Geometry

function Geometry.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function Geometry.angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

--[[
function Geometry.insideRect(px, py, x, y, w, h, angle)
    local dx = px - x
    local dy = py - y
    local cos = math.cos(angle)
    local sin = math.sin(angle)
    local rx = dx * cos + dy * sin
    local ry = -dx * sin + dy * cos
    return rx >= -w / 2 and rx <= w / 2 and ry >= -h / 2 and ry <= h / 2
end
]]

function Geometry.insideRect(px, py, x, y, w, h)
    return px >= x and px <= x + w and py >= y and py <= y + h
end

return Geometry