local State = {}
State.__index = State
function State.new()
    local self = setmetatable({}, State)
    return self
end

return State