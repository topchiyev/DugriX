
Coin = class()

function Coin:init(x, y)
    self.type = types.coin
    self.speed = 1
    self.x = x
    self.y = y
    self.angle = 0
    self.angleStep = 0.05
    self.angleDir = RIGHT

    bodySize = vec2(70,70)
    
    points = {
        vec2(0,0),
        vec2(0,bodySize.y),
        vec2(bodySize.x,bodySize.y),
        vec2(bodySize.x,0),
        vec2(0,0),
    }
    
    self.body = physics.body(POLYGON, unpack(points))
    self.body.type = DYNAMIC
    self.body.gravityScale = 0
    self.body.x = x
    self.body.y = y
    self.body.info = {
        object = self,
        size = bodySize,
    }
    self.body.interpolate = true
    self.body.sleepingAllowed = false
    self.body.fixedRotation = true
    
    self.body.categories = {types.coin}
    self.body.mask = {
        types.zero,
        types.dugrix,
        types.block,
        types.coin,
        types.ground
    }
end

function Coin:draw()
    self:move()
    self:resize()
    
    pushStyle()
    pushMatrix()
    local x = self.body.x 
    local y = self.body.y
    translate(x, y)
    
    -- Coin icon
    ellipseMode(CENTER)
    rectMode(CORNERS)
    
    local offset = self.body.info.size.x * 0.1 * (1 - self.angle)
    if self.angleDir == LEFT then
        fill(226, 94, 9, 255)
        rect(
            (self.body.info.size.x / 2) - offset,
            0,
            (self.body.info.size.x / 2),
            self.body.info.size.y
        )
        
        ellipse(
            (self.body.info.size.x / 2) - offset,
            self.body.info.size.y / 2,
            self.body.info.size.x * self.angle,
            self.body.info.size.y
        )
        
        fill(255, 195, 0, 255)
        ellipse(
            (self.body.info.size.x / 2),
            self.body.info.size.y / 2,
            self.body.info.size.x * self.angle,
            self.body.info.size.y
        )
        fill(226, 94, 9, 255)
        ellipse(
            (self.body.info.size.x / 2),
            self.body.info.size.y / 2,
            self.body.info.size.x * self.angle * 0.9,
            self.body.info.size.y * 0.9
        )
        fill(255, 195, 0, 255)
        ellipse(
            (self.body.info.size.x / 2),
            self.body.info.size.y / 2,
            self.body.info.size.x * self.angle * 0.8,
            self.body.info.size.y * 0.8
        )
    else
        fill(226, 94, 9, 255)
        rect(
            (self.body.info.size.x / 2) - offset,
            0,
            (self.body.info.size.x / 2),
            self.body.info.size.y
        )
        
        ellipse(
            (self.body.info.size.x / 2),
            self.body.info.size.y / 2,
            self.body.info.size.x * self.angle,
            self.body.info.size.y
        )
        
        fill(255, 195, 0, 255)
        ellipse(
            (self.body.info.size.x / 2) - offset,
            self.body.info.size.y / 2,
            self.body.info.size.x * self.angle,
            self.body.info.size.y
        )
        fill(226, 94, 9, 255)
        ellipse(
            (self.body.info.size.x / 2) - offset,
            self.body.info.size.y / 2,
            self.body.info.size.x * self.angle * 0.9,
            self.body.info.size.y * 0.9
        )
        fill(255, 195, 0, 255)
        ellipse(
            (self.body.info.size.x / 2) - offset,
            self.body.info.size.y / 2,
            self.body.info.size.x * self.angle * 0.8,
            self.body.info.size.y * 0.8
        )
    end
    
    if debugMode then
        noFill()
        stroke(255, 255, 255, 255)
        strokeWidth(4)
        drawPoly(self.body.points)
    end
    
    popMatrix()
    popStyle()
end

function Coin:move()
    self.body.x = self.x - (level.x * self.speed)
end

function Coin:resize()
    if self.angle >= 1 then
        self.angleDir = LEFT
    elseif self.angle <= 0 then
        self.angleDir = RIGHT
    end
    
    if self.angleDir == LEFT then
        self.angle = self.angle - self.angleStep
    else
        self.angle = self.angle + self.angleStep
    end
end

function Coin:take()
    self.body.sensor = true
    audio:play(audio.sounds.takeCoin)
    self.body.linearVelocity = vec2(0, 1000)
    statusBar:addCoin()
end

function Coin:doTake()
    if self.body.linearVelocity.y > 0 and self.body.x > HEIGHT * 3 then
        self.body:destroy()
        self.body = nil
        level.removeCoin(self)
    end
end
