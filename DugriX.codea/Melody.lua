Melody = class()

function Melody:init()
    self.notes = {
    }
    self.prevTime = 0
end

function Melody:play()
    local curTime = os.time()
    if self.prevTime+2 < curTime then
        sound(SOUND_PICKUP, 32660)
    end
end
