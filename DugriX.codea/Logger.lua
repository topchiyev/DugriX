Logger = class()

function Logger:init()
    self.stack = {}
    self.maxLen = 100
    self.w = 300
    self.h = HEIGHT - 160
    self.x = WIDTH - self.w - 20
    self.y = HEIGHT - self.h - 20
    self.bgColor = color(0, 0, 0, 100)
    self.fgColor = color(255, 255, 255, 255)
    self.theFont = "AmericanTypewriter"
    self.lastTouch = nil
    self.pan = 0
end

function Logger:log(message)
    if message == nil then
        message = "NIL"
    end
    message = "["..os.date("%M:%S").."] "..message
    if table.maxn(self.stack) >= self.maxLen then
        table.remove(self.stack, 1)
    end
    table.insert(self.stack, message)
end

function Logger:draw()
    pushStyle()
    
    if #self.stack > 0 then
        
        fill(self.bgColor)
        rect(self.x, self.y, self.w, self.h)
        
        clip(self.x + 5, self.y + 5, self.w - 10, self.h - 10)
        
        fill(self.fgColor)
        font(self.theFont)
        fontSize(16)
        textMode(CORNER)
        textWrapWidth(self.w - 10)
        text(self:toString(), self.x + 5, self.y + 5 + self.pan)
        
        noClip()
        
    end
    
    popStyle()
end

function Logger:toString()
    local msg = ""
    for i, str in ipairs(self.stack) do
        msg = msg.."\n"..str
    end
    return msg
end

function Logger:touched(touch)
    if pointIsInRect(vec2(touch.x, touch.y), Rect(self.x, self.y, self.w, self.h))
    or self.lastTouch == touch.id then
        if self.lastTouch == touch.id and touch.state == MOVING then
            self.pan = self.pan + touch.deltaY
        elseif touch.state == BEGAN then
            self.lastTouch = touch.id
        elseif touch.state == ENDED then
            self.lastTouch = nil
        end
    end
end