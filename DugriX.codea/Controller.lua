
Controller = class()

function Controller:init()
    self:initButtons()
end

function Controller:initButtons()
    local iconColor = color(255, 255, 255, 255)
    
    local bodyColor = color(255, 125, 0, 255)
    local altBodyColor = color(255, 76, 0, 255)
    local shape = {vec2(0,20), vec2(35,40), vec2(35,0)}
    self.leftButton = Button(30, 30, shape, nil, nil, bodyColor, iconColor, altBodyColor)
    
    local bodyColor = color(84, 207, 14, 255)
    local altBodyColor = color(59, 161, 24, 255)
    local shape = {vec2(0,0), vec2(0,40), vec2(35,20)}
    self.rightButton = Button(60 + 80, 30, shape, nil, nil, bodyColor, iconColor, altBodyColor)
    
    local bodyColor = color(0, 133, 255, 255)
    local altBodyColor = color(17, 60, 189, 255)
    local circle = 40
    self.actionButton = Button(WIDTH - 60 - 160, 30, nil, circle, nil, bodyColor, iconColor, altBodyColor)
    
    local bodyColor = color(255, 0, 140, 255)
    local altBodyColor = color(189, 18, 120, 255)
    local shape = {vec2(0,0), vec2(20,35), vec2(40,0)}
    self.jumpButton = Button(WIDTH - 30 - 80, 30, shape, nil, nil, bodyColor, iconColor, altBodyColor)
    
    local bodyColor = color(255, 0, 0, 255)
    local altBodyColor = color(189, 26, 17, 255)
    local shape = {
        vec2(0,0),
        vec2(0,7),
        vec2(30,0),
        vec2(30,0),
        vec2(0,7),
        vec2(30,7),
        vec2(0, 0+14),
        vec2(15, 25+14),
        vec2(30, 0+14)
    }
    self.exitButton = Button(30, HEIGHT - 30 - 80, shape, nil, nil, bodyColor, iconColor, altBodyColor)
end

function Controller:draw()
    pushStyle()
    
    self.leftButton:draw()
    self.rightButton:draw()
    self.jumpButton:draw()
    self.actionButton:draw()
    self.exitButton:draw()
    
    popStyle()
end

function Controller:isButtonsTouch(btn, touch)
    if btn.touch == touch.id
    or (btn.touch == nil and pointIsInRect(vec2(touch.x, touch.y), btn:getRect())) then
        return true
    else
        return false
    end
end

function Controller:touched(touch)
    if self:isButtonsTouch(self.leftButton, touch) then
        self.leftButton:touched(touch)
        level:leftButtonClick(touch)
    elseif self:isButtonsTouch(self.rightButton, touch) then
        self.rightButton:touched(touch)
        level:rightButtonClick(touch)
    elseif self:isButtonsTouch(self.jumpButton, touch) then
        self.jumpButton:touched(touch)
        level:jumpButtonClick(touch)
    elseif self:isButtonsTouch(self.actionButton, touch) then
        self.actionButton:touched(touch)
        if touch.state == BEGAN then
            level:actionButtonClick(touch)
        end
    elseif self:isButtonsTouch(self.exitButton, touch) then
        self.exitButton:touched(touch)
        if touch.state == ENDED then
            close()
        end
    end
end
