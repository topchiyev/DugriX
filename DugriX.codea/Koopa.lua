Koopa = class()

-- Turtle

function Koopa:init(x, y, dir, super)
    self.type = types.koopa
    self.speed = 1
    self.state = 1
    self.moveSpeed = 4
    self.levelX = 0
    self.direction = dir
    self.super = super or false
    
    if self.direction == nil then
        if math.random(2) == 1 then
            self.direction = LEFT
        else
            self.direction = RIGHT
        end
    end
    
    local bodySize = vec2(70,70)
    local bodyOffset = vec2(0,0)
    local points = {
        vec2(0,0),
        vec2(0,bodySize.y),
        vec2(bodySize.x,bodySize.y),
        vec2(bodySize.x,0),
        vec2(0,0),
    }
    self.body = physics.body(POLYGON, unpack(points))
    self.body.type = DYNAMIC
    self.body.x = x
    self.body.y = y
    self.body.info = {
        size = bodySize,
        offset = bodyOffset,
        object = self,
    }
    self.body.interpolate = true
    self.body.restitution = 0
    self.body.sleepingAllowed = false
    self.body.fixedRotation = true
    
    self.body.categories = {types.koopa}
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

function Koopa:draw()
    self:move()
    
    pushStyle()
    pushMatrix()
    
    local x = self.body.x + self.body.info.offset.x
    local y = self.body.y + self.body.info.offset.y
    local sz = self.body.info.size
    
    translate(x, y)
    
    if self.state == 1 then
        if self.direction == LEFT then
            self:drawLeft()
        elseif self.direction == RIGHT then
            self:drawRight()
        end
    end
    
    -- Panzer
    ellipseMode(CORNERS)
    rectMode(CORNERS)
    noStroke()
    fill(225, 218, 119, 255)
    ellipse(sz.x * 0.05, sz.y * 0.05, sz.x * 0.9, sz.y * 0.7)
    fill(27, 145, 92, 255)
    ellipse(sz.x * 0.1, sz.y * 0.1, sz.x * 0.9, sz.y * 0.7)
    noFill()
    strokeWidth(4)
    stroke(49, 53, 27, 255)
    line(sz.x * 0.17, sz.y * 0.35, sz.x * 0.63, sz.y * 0.63)
    line(sz.x * 0.25, sz.y * 0.25, sz.x * 0.75, sz.y * 0.55)
    line(sz.x * 0.4, sz.y * 0.17, sz.x * 0.83, sz.y * 0.43)
    line(sz.x * 0.45, sz.y * 0.65, sz.x * 0.77, sz.y * 0.3)
    line(sz.x * 0.3, sz.y * 0.6, sz.x * 0.67, sz.y * 0.22)
    line(sz.x * 0.2, sz.y * 0.5, sz.x * 0.52, sz.y * 0.17)
    
    if self.state > 1 then
        self:drawHoles()
    end
    
    if debugMode then
        noFill()
        stroke(255, 255, 255, 255)
        strokeWidth(4)
        drawPoly(self.body.points)
    end
    
    popMatrix()
    popStyle()
    
    if self.body.y < 0 and self.dieTime == nil then
        self:die()
    end
    self:doDie()
end

function Koopa:drawRight()
    local sz = self.body.info.size
    ellipseMode(CORNERS)
    rectMode(CORNERS)
    
    -- Head
    noStroke()
    fill(128, 69, 30, 255)
    ellipse(sz.x * 0.0, sz.y * 0.7, sz.x * 0.4, sz.y * 1.1)
    rect(sz.x * 0.2, sz.y * 0.2, sz.x * 0.4, sz.y * 0.9)
    fill(0, 0, 0, 255)
    rect(sz.x * 0.03, sz.y * 0.8, sz.x * 0.1, sz.y * 0.85)
    
    -- Eye
    noStroke()
    fill(0, 0, 0, 255)
    ellipse(sz.x * 0.15, sz.y * 0.85, sz.x * 0.3, sz.y * 1.0)
    
    -- Legs
    noStroke()
    fill(128, 69, 30, 255)
    ellipse(sz.x * 0.0, sz.y * 0.0, sz.x * 0.3, sz.y * 0.3)
    ellipse(sz.x * 0.7, sz.y * 0.0, sz.x * 1.0, sz.y * 0.3)
end

function Koopa:drawLeft()
    local sz = self.body.info.size
    ellipseMode(CORNERS)
    rectMode(CORNERS)
    
    -- Head
    noStroke()
    fill(128, 69, 30, 255)
    ellipse(sz.x * 0.6, sz.y * 0.7, sz.x * 1.0, sz.y * 1.1)
    rect(sz.x * 0.6, sz.y * 0.2, sz.x * 0.8, sz.y * 0.9)
    fill(0, 0, 0, 255)
    rect(sz.x * 0.9, sz.y * 0.8, sz.x * 0.97, sz.y * 0.85)
    
    -- Eye
    noStroke()
    fill(0, 0, 0, 255)
    ellipse(sz.x * 0.7, sz.y * 0.85, sz.x * 0.85, sz.y * 1.0)
    
    -- Legs
    noStroke()
    fill(128, 69, 30, 255)
    ellipse(sz.x * 0.0, sz.y * 0.0, sz.x * 0.3, sz.y * 0.3)
    ellipse(sz.x * 0.7, sz.y * 0.0, sz.x * 1.0, sz.y * 0.3)
end

function Koopa:drawHoles()
    local sz = self.body.info.size
    ellipseMode(CORNERS)
    rectMode(CORNERS)
    
    noStroke()
    fill(0, 0, 0, 255)

    ellipse(sz.x * 0.15, sz.y * 0.1, sz.x * 0.35, sz.y * 0.3)
    ellipse(sz.x * 0.6, sz.y * 0.1, sz.x * 0.8, sz.y * 0.3)
end

function Koopa:move()
    local diff = self.levelX - level.x
    if diff ~= 0 then
        self.body.x = self.body.x + (diff * self.speed)
        self.levelX = level.x
    end
    
    local landed, land = self:isLanded()
    
    if landed and self.dieTime == nil then
        if self.super and land.type == types.block then
            local pt = self.body.position
            local sz = self.body.info.size
            ptl = vec2(pt.x - 5, pt.y - 2)
            ptr = vec2(pt.x + sz.x + 5, pt.y - 2)
            
            self.isInTouch = false
            
            for i, block in ipairs(level.blocks) do
                if (self.direction == RIGHT and block.body:testPoint(ptl))
                or (self.direction == LEFT and block.body:testPoint(ptr))
                then
                    self.isInTouch = true
                end
            end
            
            if self.isInTouch == false then
                self:turn()
            end
        end
        
        if self.state == 1 then
            if self.direction == LEFT then
                self.body.x = self.body.x + self.moveSpeed
            else
                self.body.x = self.body.x - self.moveSpeed
            end
        elseif self.state == 2 then
            -- don't move
        elseif self.state == 3 then
            if self.direction == LEFT then
                self.body.x = self.body.x + (self.moveSpeed * 3)
            else
                self.body.x = self.body.x - (self.moveSpeed * 3)
            end
        end
    end
end

function Koopa:turn()
    if self.direction == LEFT then
        self.direction = RIGHT
    else
        self.direction = LEFT
    end
end

function Koopa:doDie()
    if self.dieTime ~= nil and self.dieTime + 1 < os.clock() then
        self.body:destroy()
        level:removeMonster(self)
    end
end

function Koopa:die()
    self.dieTime = os.clock()
    audio:play(audio.sounds.goombaDie)
    
    local bodySize = self.body.info.size
    bodySize.y = bodySize.y / 2
    
    local pts = {
        vec2(0,0),
        vec2(0,bodySize.y),
        vec2(bodySize.x,bodySize.y),
        vec2(bodySize.x,0),
        vec2(0,0),
    }
    
    self.body.points = pts
    self.body.info.size = bodySize
    self.body.active = false
end

function Koopa:isLanded()
    local landed = false
    local land = nil
    
    local pt1 = vec2(self.body.x, self.body.y - 1)
    local pt2 = vec2(self.body.x + self.body.info.size.x, self.body.y - 1)
    
    landed = self.jumping == true
    
    if landed == false then
        landed = (level.ground.body:testPoint(pt1) or level.ground.body:testPoint(pt2))
        land = level.ground
    end
    
    for i, blk in ipairs(level.blocks) do
        if landed == false then
            landed = (blk.body:testPoint(pt1) or blk.body:testPoint(pt2))
            land = blk
        end
    end
    
    for i, coin in ipairs(level.coins) do
        if landed == false then
            landed = (coin.body:testPoint(pt2) or coin.body:testPoint(pt2))
            land = coin
        end
    end
    
    return landed, land
end
