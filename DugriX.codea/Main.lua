supportedOrientations(LANDSCAPE_ANY)
displayMode(FULLSCREEN_NO_BUTTONS)
debugMode = false
    
function setup()
    level = Level1()
    controller = Controller()
    statusBar = StatusBar(0, 5)
    logger = Logger()
    audio = Audio()
end

function draw()
    pushStyle()

    background(255, 255, 255, 255)
    level:draw()
    controller:draw()
    statusBar:draw()
    logger:draw()

    popStyle()
end

function touched(touch)
    controller:touched(touch)
    logger:touched(touch)
end

function collide(contact)
    level:collide(contact)
end
