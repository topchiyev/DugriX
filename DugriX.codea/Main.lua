supportedOrientations(LANDSCAPE_ANY)
displayMode(FULLSCREEN_NO_BUTTONS)
    
function setup()
    level = Level1()
    controller = Controller()
    logger = Logger()
end

function draw()
    pushStyle()

    background(255, 255, 255, 255)
    level:draw()
    controller:draw()
    logger:draw()

    popStyle()
end

function touched(touch)
    controller:touched(touch)
end
 