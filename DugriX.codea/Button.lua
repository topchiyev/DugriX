
Button = class()

NORMAL = 0
PRESSED = 1

function Button:init(x, y, shape, circle, title, bodyColor, iconColor, altBodyColor, altIconColor)
    self.x = x
    self.y = y
    self.r = 80
    
    self.bodyColor = bodyColor
    self.iconColor = iconColor
    self.touch = nil
    
    if shape ~= nil then
        self.icon = mesh()
        self.icon.vertices = centerPolyInRect(shape, Rect(self.x, self.y, self.r, self.r))
    end
        
    if circle ~= nil then
        self.circle = circle
    end
    
    if title ~= nil then
        self.title = title
    end
    
    self.altBodyColor = altBodyColor or self.bodyColor
    self.altIconColor = altIconColor or self.iconColor
    
    self.state = NORMAL
end

function Button:draw()
    pushStyle()
    ellipseMode(CORNER)

    if self.state == NORMAL then
        fill(self.bodyColor)
        ellipse(self.x, self.y, self.r, self.r)
    else
        fill(self.altBodyColor)
        ellipse(self.x, self.y, self.r, self.r)
    end
    
    if self.icon ~= nil then
        self.icon:setColors(self.iconColor)
        self.icon:draw()
    elseif self.circle ~= nil then
        fill(self.iconColor)
        ellipse(
            self.x + ((self.r - self.circle)/2),
            self.y + ((self.r - self.circle)/2),
            self.circle,
            self.circle
        )
    elseif self.title ~= nil then
        fill(self.iconColor)
        textAlign(CENTER)
        textMode(CENTER)
        font("HelveticaNeue-Bold")
        fontSize(60)
        text(self.title, self.x+self.r/2, self.y+self.r/2)
    end
    
    popStyle()
end

function Button:getRect()
    return Rect(self.x, self.y, self.r, self.r)
end

function Button:touched(touch)
    if touch.state == BEGAN then
        self.touch = touch.id
        self.state = PRESSED
    elseif touch.state == ENDED then
        self.touch = nil
        self.state = NORMAL
    end
end
