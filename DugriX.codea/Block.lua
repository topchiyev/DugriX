BLOCK_TYPE_DIRT = 1
BLOCK_TYPE_GRASS = 2
BLOCK_TYPE_STONE = 3

--sprite("Planet Cute:Shadow South")

Block = class()

function Block:init(blockType, tint, x, y)
    self.type = types.block
    self.x = x
    self.y = y
    self.Y = y
    self.blockType = blockType
    self.tint = tint
    self.speed = 1
    self.img = "Planet Cute:Dirt Block"
    
    local bodySize = vec2(100,70)
    local bodyOffset = vec2(0,0)
    local points = {}
    
    if self.blockType == BLOCK_TYPE_DIRT then
        self.img = "Planet Cute:Dirt Block"
        bodySize = vec2(100,70)
        bodyOffset = vec2(0,0)
        points = {
            vec2(0,0),
            vec2(0,bodySize.y),
            vec2(bodySize.x,bodySize.y),
            vec2(bodySize.x,0),
            vec2(0,0),
        }
        self:initKaboom()
    elseif self.blockType == BLOCK_TYPE_GRASS then
        self.img = "Planet Cute:Grass Block"
        bodySize = vec2(100,70)
        bodyOffset = vec2(0,0)
        points = {
            vec2(0,0),
            vec2(0,bodySize.y),
            vec2(bodySize.x,bodySize.y),
            vec2(bodySize.x,0),
            vec2(0,0),
        }
    elseif self.blockType == BLOCK_TYPE_STONE then
        self.img = "Planet Cute:Stone Block"
        bodySize = vec2(100,70)
        bodyOffset = vec2(0,0)
        points = {
            vec2(0,0),
            vec2(0,bodySize.y),
            vec2(bodySize.x,bodySize.y),
            vec2(bodySize.x,0),
            vec2(0,0),
        }
    end
    
    self.body = physics.body(POLYGON, unpack(points))
    self.body.type = KINEMATIC
    self.body.x = x
    self.body.y = y
    self.body.info = {
        size = bodySize,
        offset = bodyOffset,
        object = self,
    }
    self.body.interpolate = true
    self.body.sleepingAllowed = false
    self.body.fixedRotation = true
    
    self.body.categories = {types.block}
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

function Block:initKaboom()
    self.kaboom = false
    self.kaboomCircles = {}
    for i = 1, 10 do
        local circle = {
            color = color(
                math.random(255),
                math.random(255),
                math.random(255),
                math.random(255)
            ),
            shape = {
                x = math.random(1, 200),
                y = math.random(1, 200),
                r = math.random(1, 200)
            }
        }
        table.insert(self.kaboomCircles, circle)
    end
    self.kaboomScale = 0.2
end

function Block:draw()
    self:move()
    self:doKick()
    
    pushStyle()
    pushMatrix()
    local x = self.body.x + self.body.info.offset.x
    local y = self.body.y + self.body.info.offset.y
    translate(x, y)
    
    spriteMode(CORNER)
    sprite(self.img)
    
    if self.blockType == BLOCK_TYPE_DIRT then
        if self.kaboom then
            for i, circle in ipairs(self.kaboomCircles) do
                fill(circle.color)
                ellipse(
                    circle.shape.x * self.kaboomScale,
                    circle.shape.y * self.kaboomScale,
                    circle.shape.r * self.kaboomScale
                )
            end
            self.kaboomScale = self.kaboomScale + 0.05
        end
    end
    
    if debugMode then
        noFill()
        stroke(255, 255, 255, 255)
        strokeWidth(4)
        drawPoly(self.body.points)
    end
    
    popMatrix()
    popStyle()
    
    if self.blockType == BLOCK_TYPE_DIRT then
        self:kill()
    end
end

function Block:move()
    self.body.x = self.x - (level.x * self.speed)
end

function Block:kick()
    if self.blockType == BLOCK_TYPE_DIRT or self.blockType == BLOCK_TYPE_GRASS then
        audio:play(audio.sounds.kickBlock)
        self.body.linearVelocity = vec2(0, 200)
    end
end

function Block:doKick()
    if self.body.linearVelocity.y ~= 0 then
        if self.body.y >= self.Y + 50 then
            self.body.linearVelocity = vec2(0, -200)
            if self.blockType == BLOCK_TYPE_DIRT then
                self.kaboom = true
                audio:play(audio.sounds.blockKaboom)
            end
        elseif self.body.y + 5 <= self.Y then
            self.body.linearVelocity = vec2(0, 0)
            self.body.y = self.Y
        end
    end
end

function Block:kill()
    if self.kaboom and self.kaboomScale > 1 then
        self.body:destroy()
        self.body = nil
        level:removeBlock(self)
    end
end
