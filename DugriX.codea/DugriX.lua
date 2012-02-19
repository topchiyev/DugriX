DugriX = class()

function DugriX:init()
    self.x = 200
    self.y = 220
    self.img = "Planet Cute:Character Boy"
    self.jumpSound = "ZgJAKwBQQEBAQEBAAAAAAB5Mcz7AglM+QABAf0BAQEBAQEBA"
    self.jumping = false
    self.falling = false
    self.maxJumpHeight = 70
    self.jumpHeight = 0
    self.jumpSpeed = 400
    self.jumpTick = 0
    
    self.moving = false
    self.moveDir = RIGHT
    self.moveStep = 2
    
    local points = {
        vec2(0,0),
        vec2(0,20),
        vec2(20,20),
        vec2(20,0),
    }
    
    self.body = physics.body(POLYGON, unpack(points))
    self.body.type = DYNAMIC
    self.body.x = WIDTH /2
    self.body.y = HEIGHT /2
end

function DugriX:draw()
    pushStyle()
    pushMatrix()
    
    self:doMove()
    self:doJump()
    sprite(self.img, self.x, self.y + self.jumpHeight)
    
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
            if self.x < WIDTH / 3 then
                self.x = self.x + self.moveStep
            else
                level.x = level.x + self.moveStep
            end
        elseif self.moveDir == LEFT then
            if self.x > 200 then
                self.x = self.x - self.moveStep
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
        sound(DATA, self.jumpSound)
    end
end

function DugriX:doJump()
    local curTick = os.clock()
    local shift = (curTick - self.jumpTick)
    self.jumpTick = curTick

    if self.jumping then
        if self.falling == false and self.jumpHeight < self.maxJumpHeight then
            self.jumpHeight = self.jumpHeight + self.jumpSpeed * shift
        else
            self.falling = true
            self.jumpHeight = self.jumpHeight - self.jumpSpeed * shift
            if (self.jumpHeight < 0) then
                self.jumping = false
                self.falling = false
                self.jumpHeight = 0
            end
        end
    end
end
