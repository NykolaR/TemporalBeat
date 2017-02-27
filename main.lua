local Input = require ("src.boundary.input")

local font = love.graphics.newImageFont ("assets/visual/font.png",
    " abcdefghijklmnopqrstuvwxyz0123456789", 1)
love.graphics.setFont (font)

local Play = require ("src.control.play")

function love.load ()
    love.graphics.setLineWidth (3)
    love.graphics.setLineJoin ("none")
end

local play = Play (8)

function love.update (dt)
    Input.handleInputs ()
    checkQuit ()

    play:update (dt)
end

function love.draw ()
    play:render ()

    if Input.keyDown (Input.KEYS.UP) then
        love.graphics.setColor (255, 255, 255, 255)
        love.graphics.print ("hi there, this is a message 11011")
    end
end

function checkQuit ()
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end
end
