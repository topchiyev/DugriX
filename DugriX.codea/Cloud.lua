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