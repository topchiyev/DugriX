Ground = class()

function Ground:init(x, y, speed, points)
    self.speed = speed
    
    self.body = physics.body(POLYGON, unpack(points))
    self.body.type = STATIC
    self.body.x = x
    self.body.y = y
    self.sleepingAllowed = false
end

function Ground:draw()
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

function Ground:move()
    self.body.x = - (level.x * self.speed)
end
