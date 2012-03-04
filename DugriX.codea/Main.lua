supportedOrientations(CurrentOrientation)
displayMode(FULLSCREEN_NO_BUTTONS)
debugMode = false

types = {
    zero = 0,
    dugrix = 1,
    goomba = 2,
    koopa = 3,
    block = 4,
    coin = 5,
    ground = 6,
}
    
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
