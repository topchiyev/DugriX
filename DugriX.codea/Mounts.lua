Mounts = class()

function Mounts:init()
    self.y = 0
    self:createMounts()
end

function Mounts:createMounts()
    self.mounts = {}
    local c1 = color(31, 84, 39, 255)
    local c2 = color(24, 161, 70, 255)
    local x = 0
    for i = 1, 20 do
        local c = getGradientColor(10, math.random(10), c1, c2)
        x = x + math.random(200, 500)
        local y = self.y
        local mnt = Mount(x, y, c)
        table.insert(self.mounts, mnt)
    end
end

function Mounts:draw()
    self:move()
    self:drawMounts()
end

function Mounts:drawMounts()
    for i, mount in ipairs(self.mounts) do
        mount:draw()
    end
    
    popStyle()
end

function Mounts:move()
    for i, mount in ipairs(self.mounts) do
       mount.offset = - (level.x * 0.7)
    end
end


Mount = class()

function Mount:init(x, y, c)
    self.x = x
    self.y = y
    self.w = math.random(500, 1000)
    self.h = math.random(700, 1000)
    self.c = c
    self.offset = 0
end

function Mount:draw()
    pushStyle()
    ellipseMode(CENTER)
    
    fill(self.c)
    ellipse(self.x + self.offset, self.y, self.w, self.h)
    
    popStyle()
end