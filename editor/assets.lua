local Assets = {}
Assets.__index = Assets
function Assets.new()
    local self = setmetatable({}, Assets)
    self.images = {}
    self.count = 0
    return self
end

function Assets:addImage(name, path)
    self.images[name] = love.graphics.newImage(path)
    self.count = self.count + 1
end

function Assets:addFolder(path)
    local files = love.filesystem.getDirectoryItems(path)
    for k, v in pairs(files) do
        local info = love.filesystem.getInfo(path .. "/" .. v)
        if info.type == "file" then
            local name = v:sub(1, -5)
            local extension = v:sub(-3)

            if extension == "png" then
                print('+ ASSET: ' .. name)
                self:addImage(name, path .. "/" .. v)
            end
        end
    end
end

return Assets