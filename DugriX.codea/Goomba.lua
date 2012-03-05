Goomba = class()

-- Mooshroom

function Goomba:init(x, y, dir, super)
    self.type = types.goomba
    self.speed = 1
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
    
    self.body.categories = {types.goomba}
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

function Goomba:draw()
    self:move()
    
    pushStyle()
    pushMatrix()
    
    local x = self.body.x + self.body.info.offset.x
    local y = self.body.y + self.body.info.offset.y
    translate(x, y)
    
    local sz = self.body.info.size
    ellipseMode(CORNERS)
    rectMode(CORNERS)
    
    -- Feet
    noStroke()
    if self.super then
        fill(178, 21, 25, 255)
    else
        fill(123, 50, 30, 255)
    end
    ellipse(sz.x * 0.2, sz.y * 0.0, sz.x * 0.5, sz.y * 0.2)
    ellipse(sz.x * 0.5, sz.y * 0.0, sz.x * 0.8, sz.y * 0.2)
    
    -- Body
    noStroke()
    if self.super then
        fill(17, 113, 195, 255)
    else
        fill(255, 172, 0, 255)
    end
    ellipse(sz.x * 0.25, sz.y * 0.05, sz.x * 0.55, sz.y * 0.4)
    ellipse(sz.x * 0.45, sz.y * 0.05, sz.x * 0.75, sz.y * 0.4)
    rect(sz.x * 0.25, sz.y * 0.2, sz.x * 0.75, sz.y * 0.4)
    rect(sz.x * 0.4, sz.y * 0.05, sz.x * 0.6, sz.y * 0.5)
    
    -- Cap
    noStroke()
    if self.super then
        fill(178, 21, 25, 255)
    else
        fill(123, 50, 30, 255)
    end
    ellipse(0, sz.y * 0.3, sz.x, sz.y * 0.8)
    ellipse(sz.x * 0.03, sz.y * 0.3, sz.x * 0.97, sz.y * 0.97)
    ellipse(sz.x * 0.1, sz.y * 0.3, sz.x * 0.9, sz.y)
    
    -- Eyes
    strokeWidth(4)
    fill(0, 0, 0, 255)
    stroke(255, 255, 255, 255)
    ellipse(sz.x * 0.2, sz.y * 0.5, sz.x * 0.4, sz.y * 0.7)
    ellipse(sz.x * 0.6, sz.y * 0.5, sz.x * 0.8, sz.y * 0.7)
    
    -- Eyebrowes
    strokeWidth(6)
    noFill()
    stroke(0, 0, 0, 255)
    line(sz.x * 0.2, sz.y * 0.8, sz.x * 0.4, sz.y * 0.8)
    line(sz.x * 0.6, sz.y * 0.8, sz.x * 0.8, sz.y * 0.8)
    line(sz.x * 0.4, sz.y * 0.8, sz.x * 0.5, sz.y * 0.7)
    line(sz.x * 0.5, sz.y * 0.7, sz.x * 0.6, sz.y * 0.8)
    
    -- Mouth
    stroke(255, 255, 255, 255)
    line(sz.x * 0.35, sz.y * 0.35, sz.x * 0.65, sz.y * 0.35)
    line(sz.x * 0.35, sz.y * 0.35, sz.x * 0.35, sz.y * 0.3)
    line(sz.x * 0.4, sz.y * 0.35, sz.x * 0.35, sz.y * 0.3)
    line(sz.x * 0.65, sz.y * 0.35, sz.x * 0.65, sz.y * 0.3)
    line(sz.x * 0.6, sz.y * 0.35, sz.x * 0.65, sz.y * 0.3)
    
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

function Goomba:move()
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
        
        if self.direction == LEFT then
            self.body.x = self.body.x + self.moveSpeed
        else
            self.body.x = self.body.x - self.moveSpeed
        end
    end
end

function Goomba:turn()
    if self.direction == LEFT then
        self.direction = RIGHT
    else
        self.direction = LEFT
    end
end

function Goomba:doDie()
    if self.dieTime ~= nil and self.dieTime + 1 < os.clock() then
        self.body:destroy()
        level:removeMonster(self)
    end
end

function Goomba:die()
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

function Goomba:isLanded()
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
