DugriX = class()

function DugriX:init()
    self.img = "Planet Cute:Character Boy"
    self.jumpSound = "ZgJAKwBQQEBAQEBAAAAAAB5Mcz7AglM+QABAf0BAQEBAQEBA"
    self.jumping = false
    self.jumpHeight = 0
    self.maxJumpHeight = 200
    self.jumpTick = 0
    
    self.moving = false
    self.moveDir = RIGHT
    self.moveStep = 2
    
    local bodySize = vec2(90,100)
    local bodyOffset = vec2(-5,-20)
    
    local points = {
        vec2(0,0),
        vec2(0,bodySize.y),
        vec2(bodySize.x,bodySize.y),
        vec2(bodySize.x,0),
    }
    
    self.body = physics.body(POLYGON, unpack(points))
    self.body.type = DYNAMIC
    self.body.x = 200
    self.body.y = 500--220
    self.body.info = {
        size = bodySize,
        offset = bodyOffset
    }
    self.body.interpolate = true
    self.body.restitutions = 0.25
    self.body.sleepingAllowed = false
    self.body.fixedRotation = true
end

function DugriX:draw()
    pushStyle()
    pushMatrix()
    
    self:doMove()
    self:doJump()
    
    spriteMode(CORNER)
    local offset = self.body.info.offset
    sprite(self.img, self.body.x + offset.x, self.body.y + offset.y)
    
    translate(self.body.x, self.body.y)
    strokeWidth(10)
    for i = 1, #self.body.points do
        local a = self.body.points[i]
        local b = self.body.points[(i % #self.body.points)+1]
        line(a.x, a.y, b.x, b.y)
    end
    
    popMatrix()
    popStyle()
end

function DugriX:move(dir)
    self.moving = true
    self.moveDir = dir
end

function DugriX:stop()
    self.moving = false
end

function DugriX:doMove()
    if self.moving then
        if self.moveDir == RIGHT then
            if self.body.x < WIDTH / 3 then
                self.body.x = self.body.x + self.moveStep
            else
                level.x = level.x + self.moveStep
            end
        elseif self.moveDir == LEFT then
            if self.body.x > 200 then
                self.body.x = self.body.x - self.moveStep
            else
                if level.x > 50 then
                    level.x = level.x - self.moveStep
                end
            end
        end
    end
end

function DugriX:jump()
    if self.jumping == false then
        self.jumping = true
        self.originalX = self.body.x
        self.body:applyForce(vec2(0, 5000))
        sound(DATA, self.jumpSound)
    end
    
    --if self.jumping == false then
    --    self.body:applyForce(vec2(100, 100))
    --    self.jumping = true
    --    sound(DATA, self.jumpSound)
    --end
end

function DugriX:fall()
    self.jumping = false
end

function DugriX:doJump()
    if self.jumping then
        local curTick = os.clock()
        local shift = (curTick - self.jumpTick)
        self.jumpTick = curTick
        logger:log("shift"..shift)
        

    
        if self.body:testOverlap(level.ground.body) then
            logger:log("landed")
        end
    end
end

function DugriX:doJumpOld()
    local curTick = os.clock()
    local shift = (curTick - self.jumpTick)
    self.jumpTick = curTick

    if self.jumping then
        if self.falling == false and self.jumpHeight < self.maxJumpHeight then
            self.jumpHeight = self.jumpHeight + 1 * shift
        else
            self.falling = true
            self.jumpHeight = self.jumpHeight - 1 * shift
            if (self.jumpHeight < 0) then
                self.jumping = false
                self.falling = false
                self.jumpHeight = 0
            end
        end
    end
end
