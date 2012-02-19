Logger = class()

function Logger:init()
    self.log = {}
    self.maxLen = 25
    self.w = 300
    self.h = HEIGHT - 160
    self.x = WIDTH - self.w - 20
    self.y = HEIGHT - self.h - 20
    self.bgColor = color(0, 0, 0, 100)
    self.fgColor = color(255, 255, 255, 255)
end

function Logger:add(message)
    if message == nil then
        message = "NIL"
    end
    message = "["..os.date("%M:%S").."] "..message
    if table.maxn(self.log) >= self.maxLen then
        table.remove(self.log, 1)
    end
    table.insert(self.log, message)
end

function Logger:draw()
    pushStyle()
    
    if #self.log > 0 then
        
        fill(self.bgColor)
        rect(self.x, self.y, self.w, self.h)
        
        fill(self.fgColor)
        font("AmericanTypewriter")
        fontSize(16)
        textMode(CORNER)
        textWrapWidth(self.w - 10)
        text(self:toString(), self.x + 5, self.y + 5)
        
    end
    
    popStyle()
end

function Logger:toString()
    local msg = ""
    for i, str in ipairs(self.log) do
        msg = msg.."\n"..str
    end
    return msg
end

function Logger:touched(touch)
    -- Codea does not automatically call this method
end
