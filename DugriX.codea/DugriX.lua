DugriX = class()

function DugriX:init()
    self.type = "dugrix"
    self.img = "Planet Cute:Character Boy"
    self.jumpNum = 0
    self.initialPos = vec2(200, 500)
    
    self.moving = false
    self.moveDir = RIGHT
    self.moveStep = 6
    
    local bodySize = vec2(70,80)
    local bodyOffset = vec2(-15,-30)
    
    local points = {
        vec2(0,0),
        vec2(0,bodySize.y),
        vec2(bodySize.x,bodySize.y),
        vec2(bodySize.x,0),
    }
    
    self.body = physics.body(POLYGON, unpack(points))
    self.body.type = DYNAMIC
    self.body.x = self.initialPos.x
    self.body.y = self.initialPos.y
    self.body.info = {
        size = bodySize,
        offset = bodyOffset,
        object = self,
    }
    self.body.interpolate = true
    self.body.restitution = 0
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
    
    popMatrix()
    popStyle()
end

function DugriX:drawBody()
    pushStyle()
    pushMatrix()
    
    translate(self.body.x, self.body.y)
    strokeWidth(4)
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
        local step = self.moveStep
        if self:isLanded() == false then
            step = step + 1
        end
        
        if self.moveDir == RIGHT then
            if self.body.x < WIDTH / 3 then
                self.body.x = self.body.x + step
            else
                level.x = level.x + step
            end
        elseif self.moveDir == LEFT then
            if self.body.x > 200 then
                self.body.x = self.body.x - step
            else
                if level.x > 50 then
                    level.x = level.x - step
                end
            end
        end
    end
end

function DugriX:jump()
    if (self.jumpNum == 0 and self:isLanded()) or self.jumpNum == 1 then
        self.jumpNum = self.jumpNum + 1
        if self.jumpNum == 1 then
            self.body:applyForce(vec2(0, 3000))
        elseif self.jumpNum == 2 then
            self.body:applyForce(vec2(0, 1500))
        end
        audio:play(audio.sounds.jump)
    end
end

function DugriX:fall()
    self.jumping = false
end

function DugriX:doJump()
    if self.jumpNum > 0 and self:isLanded() then
        self.jumpNum = 0
    end
end

function DugriX:isLanded()
    local landed = false
    local pt1 = vec2(self.body.x, self.body.y - 1)
    local pt2 = vec2(self.body.x + self.body.info.size.x, self.body.y - 1)
    
    landed = self.jumping == true
    
    if landed == false then
        landed = (level.ground.body:testPoint(pt1) or level.ground.body:testPoint(pt2))
    end
    
    for i, blk in ipairs(level.blocks) do
        if landed == false then
            landed = (blk.body:testPoint(pt1) or blk.body:testPoint(pt2))
        end
    end
    
    for i, coin in ipairs(level.coins) do
        if landed == false then
            landed = (coin.body:testPoint(pt2) or coin.body:testPoint(pt2))
        end
    end
    
    return landed
end

function DugriX:die()
    statusBar.lifes = statusBar.lifes - 1
    if statusBar.lifes <= 0 then
        return true
    else
        return false
    end
end
