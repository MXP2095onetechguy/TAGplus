local home = {} -- A table for exporting the methods

-- Home screen things to keep
local logo = nil
local exitRequester = nil -- A method used for dealing with chaning game state -> function(newState, turbMode)

-- Buttons
local GAMEBTN = nil -- Play button
local JUKEBTN = nil -- Jukebox button
local CREDITSBTN = nil -- Credits button
local EXITBTN = nil -- Exit button

function inBoxRange(mx, my, rx, ry, rw, rh) -- A function used to check if mouse x and mouse y is in box?
    if (mx >= rx and mx <= (rx+rw)) then
        if my >= ry and my <= (ry+rh) then
            return true
        end
    end
    return false
end

function home.load(love, exitrequester)
    exitRequester = exitrequester -- set the exitRequester
    logo = love.graphics.newImage("assets/image/logo.png") -- Load the image

    -- Initialize buttons
    do
        local sw = love.graphics.getWidth()
        local sh = love.graphics.getHeight()
        local height = 30

        GAMEBTN = {}
        GAMEBTN.color = {
            r = 0,
            g = 0.5,
            b = 0,
            a = 1
        }
        GAMEBTN.msgColor = {
            r = 0,
            g = 0,
            b = 0,
            a = 1
        }
        GAMEBTN.x = 0
        GAMEBTN.msg = "Play!"
        GAMEBTN.height = height
        GAMEBTN.y = sh - height
        GAMEBTN.width = sw/4

        JUKEBTN = {}
        JUKEBTN.color = {
            r = 1,
            g = 1,
            b = 0,
            a = 1
        }
        JUKEBTN.msgColor = {
            r = 0,
            g = 0,
            b = 0,
            a = 1
        }
        JUKEBTN.x = GAMEBTN.x + GAMEBTN.width
        JUKEBTN.msg = "Jukebox"
        JUKEBTN.height = height
        JUKEBTN.y = sh - height
        JUKEBTN.width = sw/4

    end
end

function home.update(love, dt)
end

function home.draw(love)
    do -- Draw the logo
        local sw = love.graphics.getWidth() -- Get screen width
        local sh = love.graphics.getHeight() -- Get screen height
        love.graphics.setColor(1, 1, 1, 1) --- Set color
        love.graphics.draw(logo, (sw/2)-(logo:getWidth()/2), sh/4, 0, 0.5, 0.5)
    end

    do -- Draw buttons
        local font = love.graphics.getFont()

        do -- Play button
            love.graphics.setColor(GAMEBTN.color.r, GAMEBTN.color.g, GAMEBTN.color.b, GAMEBTN.color.a)
            love.graphics.rectangle("fill", GAMEBTN.x, GAMEBTN.y, GAMEBTN.width, GAMEBTN.height)
            love.graphics.setColor(GAMEBTN.msgColor.r, GAMEBTN.msgColor.g, GAMEBTN.msgColor.b, GAMEBTN.msgColor.a)
            love.graphics.print(GAMEBTN.msg, 
                (GAMEBTN.x + (GAMEBTN.width/2)) - font:getWidth(GAMEBTN.msg), 
                (GAMEBTN.y + GAMEBTN.height) - font:getHeight(GAMEBTN.msg)
            )
        end

        do -- Jukebox button
            love.graphics.setColor(JUKEBTN.color.r, JUKEBTN.color.g, JUKEBTN.color.b, JUKEBTN.color.a)
            love.graphics.rectangle("fill", JUKEBTN.x, JUKEBTN.y, JUKEBTN.width, JUKEBTN.height)
            love.graphics.setColor(JUKEBTN.msgColor.r, JUKEBTN.msgColor.g, JUKEBTN.msgColor.b, JUKEBTN.msgColor.a)
            love.graphics.print(JUKEBTN.msg, 
                (JUKEBTN.x + (JUKEBTN.width/2)) - font:getWidth(JUKEBTN.msg), 
                (JUKEBTN.y + JUKEBTN.height) - font:getHeight(JUKEBTN.msg)
            )
        end
    end
end

function home.mousepressed(x, y, btn, _)
    if exitRequester then
        if inBoxRange(x, y, GAMEBTN.x, GAMEBTN.y, GAMEBTN.width, GAMEBTN.height) then
            local turbTime = love.window.showMessageBox("Game time!", "Would you like Turb mode for a hard mode?", {"Yes", "No"}, "info", true) == 1
            exitRequester("GAME", turbTime)
        end

        if inBoxRange(x, y, JUKEBTN.x, JUKEBTN.y, JUKEBTN.width, JUKEBTN.height) then
            exitRequester("JUKEBOX")
        end
    end
end

return home