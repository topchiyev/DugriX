Level1 = class()

function Level1:init()
    self.x = 0
    self.sky = Sky()
    self.mounts = Mounts()
    self:initBgs()
    self:initBlocks()
    self:initCoins()
    self:initGround()
    self:initMonsters()
    self:initCheckPts()
    self.dugrix = DugriX(self.checkPts[1])
end

function Level1:initCheckPts()
    self.checkPts = {
        vec2(200, 500),
    }
end

function Level1:getNearestCheckPt()
    local checkPt = vec2(0,0)
    
    for i, pt in ipairs(self.checkPts) do
        if pt.x >= checkPt.x and pt.x <= self.x then
            checkPt = pt
        end
    end
    
    return checkPt
end

function Level1:initBgs()
    self.bgs = {}
    local imgs = {}
    --sprite("Planet Cute:Rock")
    
    -- Tree and house road
    imgs = {
        { img = "Planet Cute:Grass Block", x = 0 },
        { img = "Planet Cute:Grass Block", x = 100 },
        { img = "Planet Cute:Grass Block", x = 200 },
        { img = "Planet Cute:Grass Block", x = 300 },
        
        { img = "Planet Cute:Stone Block", x = 400 },
        { img = "Planet Cute:Stone Block", x = 500 },
        { img = "Planet Cute:Stone Block", x = 600 },
    }
    for i = 8,13 do
        table.insert(imgs, { img = "Planet Cute:Grass Block", x = (i-1) * 100 })
    end
    for i = 15,24 do
        table.insert(imgs, { img = "Planet Cute:Grass Block", x = (i-1) * 100 })
    end
    table.insert(self.bgs, Background(200, 1, imgs))

    -- Tree and house level 1
    imgs = {
        { img = "Planet Cute:Tree Ugly", x = 100 },
        { img = "Planet Cute:Tree Tall", x = 300 },
        { img = "Planet Cute:Wall Block Tall", x = 400 },
        { img = "Planet Cute:Window Tall", x = 500 },
        { img = "Planet Cute:Wall Block Tall", x = 600 },
        { img = "Planet Cute:Tree Tall", x = 700 },
        { img = "Planet Cute:Tree Ugly", x = 1100 },
        { img = "Planet Cute:Tree Tall", x = 1700 },
        { img = "Planet Cute:Rock", x = 1900 },
        { img = "Planet Cute:Tree Short", x = 2000 },
    }
    table.insert(self.bgs, Background(240, 1, imgs))
    
    -- Tree and house level 2
    imgs = {
        { img = "Planet Cute:Wall Block Tall", x = 400 },
        { img = "Planet Cute:Wall Block Tall", x = 500 },
        { img = "Planet Cute:Wall Block Tall", x = 600 },
    }
    table.insert(self.bgs, Background(325, 1, imgs))
    
    -- Tree and house level 3
    imgs = {
        { img = "Planet Cute:Roof South West", x = 400 },
        { img = "Planet Cute:Roof South", x = 500 },
        { img = "Planet Cute:Roof South East", x = 600 },
    }
    table.insert(self.bgs, Background(410, 1, imgs))
    
    -- Hero road level 1
    imgs = {}
    for i = 1, 13 do
        table.insert(imgs, { img = "Planet Cute:Dirt Block", x = (i-1) * 100 })
    end
    for i = 15, 24 do
        table.insert(imgs, { img = "Planet Cute:Dirt Block", x = (i-1) * 100 })
    end
    table.insert(self.bgs, Background(-40, 1, imgs))
    table.insert(self.bgs, Background(0, 1, imgs))
    table.insert(self.bgs, Background(40, 1, imgs))
    table.insert(self.bgs, Background(80, 1, imgs))
    
    -- Hero road level 2 (Main)
    imgs = {}
    for i = 1, 12 do
        table.insert(imgs, { img = "Planet Cute:Stone Block", x = (i-1) * 100 })
    end
    table.insert(imgs, { img = "Planet Cute:Stone Block Tall", x = 1200 })
    table.insert(imgs, { img = "Planet Cute:Stone Block Tall", x = 1400 })
    for i = 16, 24 do
        table.insert(imgs, { img = "Planet Cute:Stone Block", x = (i-1) * 100 })
    end
    table.insert(self.bgs, Background(120, 1, imgs))
    
    -- Hero road level 3
    imgs = {
        { img = "Planet Cute:Ramp West", x = 1100 },
        { img = "Planet Cute:Ramp East", x = 1500 },
    }
    table.insert(self.bgs, Background(160, 1, imgs))
    
end

function Level1:initGround()
    local points = {
        vec2(0,-10),
        vec2(0,190),
        vec2(1100,190),
        vec2(1200,225),
        vec2(1300,225),
        vec2(1300,-10),
        vec2(1400,-10),
        vec2(1400,225),
        vec2(1500,225),
        vec2(1600,190),
        vec2(2400,190),
        vec2(2400,-10),
    }
    self.ground = Ground(0, 0, 1, points)
end

function Level1:initBlocks()
    self.blocks = {
        Block(BLOCK_TYPE_GRASS, nil, 800, 350),
        Block(BLOCK_TYPE_DIRT, nil, 900, 350),
        Block(BLOCK_TYPE_STONE, nil, 1000, 350),
        
        Block(BLOCK_TYPE_STONE, nil, 1900, 160),
        Block(BLOCK_TYPE_STONE, nil, 2300, 160),
    }
end

function Level1:initCoins()
    self.coins = {
        Coin(815, 450),
        Coin(915, 450),
        Coin(1015, 450),
    }
end

function Level1:initMonsters()
    self.monsters = {
        Koopa(850, 500, nil, true),
        Goomba(2100, 500),
    }
end

function Level1:draw()
    self.sky:draw()
    self.mounts:draw()
    
    for i, bg in ipairs(self.bgs) do
        bg:draw()
    end
    
    for i, blk in ipairs(self.blocks) do
        blk:draw()
    end
    
    for i, coin in ipairs(self.coins) do
        coin:draw()
    end
    
    for i, monster in ipairs(self.monsters) do
        monster:draw()
    end
    
    self.ground:draw()
    self.dugrix:draw()
end

function Level1:collide(contact)
    local a = contact.bodyA
    local b = contact.bodyB
    local ta = a.info.object.type
    local tb = b.info.object.type
    
    if ta == types.block or tb == types.block then
        self:collideBlock(contact)
    elseif ta == types.coin or tb == types.coin then
        self:collideCoin(contact)
    elseif ta == types.goomba or tb == types.goomba then
        self:collideGoomba(contact)
    elseif ta == types.koopa or tb == types.koopa then
        self:collideKoopa(contact)
    end
end

function Level1:collideBlock(contact)
    local a = contact.bodyA
    local b = contact.bodyB
    
    if b.info.object.type == types.block then
        local c = a
        a = b
        b = c
    end
    
    if contact.state == BEGAN then
        if b.info.object.type == types.dugrix
        and a.y > b.y and b.x + b.info.size.x > a.x then
            a.info.object:kick()
        elseif b.info.object.type == types.coin then
            b.info.object:take()
        elseif b.info.object.type == types.goomba
        or b.info.object.type == types.koopa then
            local pt1 = vec2(b.x - 1, b.y + (b.info.size.y / 2))
            local pt2 = vec2(b.x + b.info.size.x + 1, pt1.y)
            if a:testPoint(pt1) or a:testPoint(pt2) then
                b.info.object:turn()
            end
        end
    elseif (b.info.object.type == types.goomba or b.info.object.type == types.koopa)
    and a.y > a.info.object.Y + 50 then
        b.info.object:die()
    end
end

function Level1:collideCoin(contact)
    local a = contact.bodyA
    local b = contact.bodyB
    
    if b.info.object.type == types.coin then
        local c = a
        a = b
        b = c
    end
    
    if contact.state == BEGAN
    and (b.info.object.type == types.dugrix or b.info.object.type == types.block)
    then
        a.info.object:take()
    end
end

function Level1:collideGoomba(contact)
    local a = contact.bodyA
    local b = contact.bodyB
    
    if b.info.object.type == types.goomba then
        local c = a
        a = b
        b = c
    end
    
    if contact.state == BEGAN
    and b.info.object.type == types.dugrix
    then
        if b.y > a.y + a.info.size.y then
            a.info.object:die()
        else
            b.info.object:die()
        end
    end
end

function Level1:collideKoopa(contact)
    local a = contact.bodyA
    local b = contact.bodyB
    
    if b.info.object.type == types.koopa then
        local c = a
        a = b
        b = c
    end
    
    if contact.state == BEGAN and b.info.object.type == types.dugrix then
        if a.info.object.state == 1 and b.y > a.y + a.info.size.y then
            a.info.object.state = 2
        elseif a.info.object.state == 2 then
            a.info.object.state = 3
        elseif a.info.object.state == 3 and b.y > a.y + a.info.size.y then
            a.info.object.state = 2
        else
            b.info.object:die()
        end
    end
end

function Level1:removeCoin(coin)
    for i = 0, #self.coins do
        if coin == self.coins[i] then
            table.remove(self.coins, i)
        end
    end
end

function Level1:removeBlock(block)
    for i = 0, #self.blocks do
        if block == self.blocks[i] then
            table.remove(self.blocks, i)
        end
    end
end

function Level1:removeMonster(monster)
    for i = 0, #self.monsters do
        if monster == self.monsters[i] then
            table.remove(self.monsters, i)
        end
    end
end

function Level1:jumpButtonClick(touch)
    if touch.state == BEGAN then
        self.dugrix:jump()
    elseif touch.state == ENDED then
        self.dugrix:fall()
    end
end

function Level1:rightButtonClick(touch)
    if touch.state == ENDED then
        self.dugrix:stop()
    else
        self.dugrix:move(RIGHT)
    end
end

function Level1:leftButtonClick(touch)
    if touch.state == ENDED then
        self.dugrix:stop()
    else
        self.dugrix:move(LEFT)
    end
end

function Level1:actionButtonClick()
    -- TODO:
end
