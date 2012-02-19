Level1 = class()

function Level1:init()
    self.x = 0
    self.sky = Sky()
    self:initBgs()
    self:initGround()
    self.dugrix = DugriX()
end

function Level1:initBgs()
    self.bgs = {}
    local imgs = {}
    sprite("Planet Cute:Stone Block Tall")
    
    -- Tree and house road
    imgs = {
        { img = "Planet Cute:Grass Block", x = 0 },
        { img = "Planet Cute:Grass Block", x = 100 },
        { img = "Planet Cute:Grass Block", x = 200 },
        { img = "Planet Cute:Grass Block", x = 300 },
        
        { img = "Planet Cute:Stone Block", x = 400 },
        { img = "Planet Cute:Stone Block", x = 500 },
        { img = "Planet Cute:Stone Block", x = 600 },
        
        { img = "Planet Cute:Grass Block", x = 700 },
        { img = "Planet Cute:Grass Block", x = 800 },
        { img = "Planet Cute:Grass Block", x = 900 },
        { img = "Planet Cute:Grass Block", x = 1000 },
        { img = "Planet Cute:Grass Block", x = 1100 },
        { img = "Planet Cute:Grass Block", x = 1200 },
    }
    table.insert(self.bgs, Background(270, 1, imgs))

    -- Tree and house level 1
    imgs = {
        { img = "Planet Cute:Tree Ugly", x = 100 },
        { img = "Planet Cute:Tree Tall", x = 300 },
        { img = "Planet Cute:Wall Block Tall", x = 400 },
        { img = "Planet Cute:Window Tall", x = 500 },
        { img = "Planet Cute:Wall Block Tall", x = 600 },
        { img = "Planet Cute:Tree Tall", x = 700 },
        { img = "Planet Cute:Tree Ugly", x = 1100 },
    }
    table.insert(self.bgs, Background(310, 1, imgs))
    
    -- Tree and house level 2
    imgs = {
        { img = "Planet Cute:Wall Block Tall", x = 400 },
        { img = "Planet Cute:Wall Block Tall", x = 500 },
        { img = "Planet Cute:Wall Block Tall", x = 600 },
    }
    table.insert(self.bgs, Background(395, 1, imgs))
    
    -- Tree and house level 3
    imgs = {
        { img = "Planet Cute:Roof South West", x = 400 },
        { img = "Planet Cute:Roof South", x = 500 },
        { img = "Planet Cute:Roof South East", x = 600 },
    }
    table.insert(self.bgs, Background(480, 1, imgs))
    
    -- Hero road level 1
    imgs = {}
    for i = 1, 13 do
        imgs[i] = { img = "Planet Cute:Dirt Block", x = (i-1) * 100 }
    end
    table.insert(self.bgs, Background(65, 1, imgs))
    table.insert(self.bgs, Background(105, 1, imgs))
    table.insert(self.bgs, Background(145, 1, imgs))
    
    -- Hero road level 2 (Main)
    imgs = {}
    for i = 1, 12 do
        imgs[i] = { img = "Planet Cute:Stone Block", x = (i-1) * 100 }
    end
    imgs[13] = { img = "Planet Cute:Stone Block Tall", x = 1200 }
    table.insert(self.bgs, Background(185, 1, imgs))
    
    -- Hero road level 3
    imgs = {
        { img = "Planet Cute:Ramp West", x = 1100 },
    }
    table.insert(self.bgs, Background(225, 1, imgs))

end

function Level1:initGround()
    local points = {
        vec2(0,-10),
        vec2(0,185),
        vec2(1000,185),
        vec2(1000,-10),
    }
    self.ground = Ground(0, 0, 1, points)
end

function Level1:draw()
    self.sky:draw()
    
    for i, bg in ipairs(self.bgs) do
        bg:draw()
    end
    
    self.ground:move()
    self.ground:draw()
    
    self.dugrix:draw()
end

function Level1:jumpButtonClick(touch)
    if touch.state == BEGAN then
        self.dugrix:jump()
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
