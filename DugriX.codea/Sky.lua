Sky = class()

function Sky:init()
    self.dist = 700
    self.y = 100
    self:createClouds()
end

function Sky:createClouds()
    self.clouds = {}
    local c1 = color(232, 235, 237, 250)
    local c2 = color(255, 255, 255, 250)
    for i = 1, 10 do
        local c = getGradientColor(10, math.random(10), c1, c2)
        local x = ((i - 1) * self.dist) 
            + math.random(self.dist * 0.5, self.dist)
        local y = HEIGHT - self.y
        local cl = Cloud(x, y, c)
        table.insert(self.clouds, cl)
    end
end

function Sky:draw()
    self:move()
    
    self:drawBackground()
    self:drawClouds()
end

function Sky:drawBackground()
    pushStyle()
    noStroke()
    
    c1 = color(216, 229, 231, 255)
    c2 = color(0, 175, 255, 255)
    
    h = HEIGHT / 10
    w = WIDTH
    x = 0
    
    for i = 0, 20 do
        y = i * h
        c = getGradientColor(10, i, c1, c2)
        fill(c)
        rect(x - 2, y, w + 2, h + 2)
    end
    
    popStyle()
end

function Sky:drawClouds()
    for i, cl in ipairs(self.clouds) do
        cl:draw()
    end
    
    popStyle()
end

function Sky:move()
    for i, cl in ipairs(self.clouds) do
       cl.offset = - (level.x * 0.5)
    end
end


Cloud = class()

function Cloud:init(x, y, c)
    self.x = x
    self.y = y
    self.c = c
    self.offset = 0
    self.shapes = {}
    
    numCircles = math.random(4, 5)
    spacing = 60
    
    for i = 1, numCircles do
        x = i * spacing - ((numCircles / 2) * spacing)
        y = (math.random() - 0.5) * 60
        rad = math.random(spacing, 2 * spacing)     
        table.insert(self.shapes, {x=x, y=y, r=rad})
    end
  
    self.width = numCircles * spacing + spacing
end

function Cloud:draw()
    pushStyle()
    ellipseMode(CENTER)

    for i, sh in ipairs(self.shapes) do
        fill(82, 162, 232, 255)
        ellipse(self.x + self.offset + sh.x, self.y + sh.y - 5, sh.r)
    end
    
    for i, sh in ipairs(self.shapes) do
        fill(self.c)
        ellipse(self.x + self.offset + sh.x, self.y + sh.y, sh.r, sh.r * 0.8)
    end
    
    popStyle()
end