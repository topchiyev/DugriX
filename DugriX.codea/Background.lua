Background = class()

function Background:init(y, speed, imgs)
    self.y = y
    self.speed = speed
    self.imgs = imgs
end

function Background:draw()
    self:move()
    
    pushStyle()
    
    spriteMode(CORNER)
    
    for i, img in ipairs(self.imgs) do
        sprite(img.img, img.offset + img.x , self.y)
    end
    
    popStyle()
end

function Background:move()
    for i, img in ipairs(self.imgs) do
       img.offset = - (level.x * self.speed)
    end
end
