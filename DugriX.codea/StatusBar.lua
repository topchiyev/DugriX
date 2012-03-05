StatusBar = class()

function StatusBar:init(coins, lifes)
    self.coins = coins or {}
    self.lifes = lifes or {}
end

function StatusBar:addCoin()
    self.coins = self.coins + 1
    if math.modf(#self.coins / 100) == 0 then
        self:addLife()
    end
end

function StatusBar:addLife()
    self.lifes = self.lifes + 1
end

function StatusBar:removeLife()
    self.lifes = self.lifes - 1
end

function StatusBar:draw()
    pushStyle()
    pushMatrix()
    
    noStroke()
    
    local w = 300
    local h = 50
    local x = WIDTH - w - 50
    local y = HEIGHT - h - 50
    
    translate(x, y)
    
    -- Coin icon
    ellipseMode(CORNER)
    fill(226, 94, 9, 255)
    ellipse(0, -3, 50, 50)
    fill(255, 195, 0, 255)
    ellipse(0, 0, 50, 50)
    fill(226, 94, 9, 255)
    ellipse(2.5, 2.5, 45, 45)
    fill(255, 195, 0, 255)
    ellipse(4, 4, 42, 42)
    
    -- Coin count
    textMode(CORNER)
    fontSize(50)
    font("ArialRoundedMTBold")
    textAlign()
    fill(22, 68, 175, 255)
    text(""..self.coins, 60, -5)
    fill(255, 255, 255, 255)
    text(""..self.coins, 60, -2)
    
    -- Heart icon
    local pts = {
        vec2(30, 0),
        vec2(0, 30),
        vec2(0, 30),
        vec2(0, 40),
        vec2(10, 50),
        vec2(20, 50),
        vec2(30, 40),
        vec2(40, 50),
        vec2(50, 50),
        vec2(60, 40),
        vec2(60, 30),
        vec2(30, 0),
    }
    local heart = mesh()
    heart.vertices = triangulate(pts)
    translate(150, -4)
    heart:setColors(color(195, 17, 17, 255))
    heart:draw()
    fill(195, 17, 17, 255)
    ellipse(-3.5, 21, 35)
    ellipse(30-2.5, 21, 35)
    translate(0, 4)
    heart:setColors(color(255, 0, 0, 255))
    heart:draw()
    fill(255, 0, 0, 255)
    ellipse(-3.5, 21, 35)
    ellipse(30-2.5, 21, 35)
    
    -- Life count
    translate(20, 0)
    textMode(CORNER)
    fontSize(50)
    font("ArialRoundedMTBold")
    textAlign()
    fill(22, 68, 175, 255)
    text(""..self.lifes, 60, -5)
    fill(255, 255, 255, 255)
    text(""..self.lifes, 60, -2)
    
    popMatrix()
    popStyle()
end
