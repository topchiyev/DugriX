Ground = class()

function Ground:init(x, y, speed, points)
    self.type = types.ground
    self.speed = speed
    
    self.body = physics.body(POLYGON, unpack(points))
    self.body.type = STATIC
    self.body.info = {
        object=self
    }
    self.body.x = x
    self.body.y = y
    self.sleepingAllowed = false
    
    self.body.categories = {types.ground}
    self.body.mask = {
        types.zero,
        types.dugrix,
        types.goomba,
        types.koopa,
        types.block,
        types.coin,
        types.ground
    }
end

function Ground:draw()
    self:move()
    
    if debugMode then
        pushStyle()
        pushMatrix()
        
        translate(self.body.x, self.body.y)
        strokeWidth(4)
        for i = 1, #self.body.points-1 do
            local a = self.body.points[i]
            local b = self.body.points[i+1]
            line(a.x, a.y, b.x, b.y)
        end
        
        popMatrix()
        popStyle()
    end
end

function Ground:move()
    self.body.x = - (level.x * self.speed)
end
