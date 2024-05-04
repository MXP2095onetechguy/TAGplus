local game = {} -- A table for exporting the methods

local gameConf = {} -- Get config for game

-- Game Info Thingys
local font = nil
local UIRect = {}

-- Game states
local score = 0 -- Score
local helth = 10 -- Helth

-- Game objects
local world = nil -- Physics world

function game.load(love) -- Onload game
    do -- A block of code for getting Love2D configuration if needed
        local libConf = require("conf")
        libConf.fillConf(gameConf)
        libConf.getConf(gameConf)
    end

    -- Get font
    font = love.graphics.getFont()

    do -- Setup physics
        local meterPx = 64
        love.physics.setMeter(meterPx)
        world = love.physics.newWorld(0, 9.81*meterPx, true)
    end

    UIRect.x = 0
    UIRect.y = love.graphics.getHeight() - 30
    UIRect.width = love.graphics.getWidth()
    UIRect.height = 30
end

function game.update(love, dt) -- Update game
    world:update(dt)
end

function game.draw(love) -- Paint the game
    do -- Painting Game UI
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", UIRect.x, UIRect.y, UIRect.width, UIRect.height)

        local textYpos = UIRect.y

        do -- Print text -> FPS, Lives, Score
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(
                "FPS(" .. love.timer.getFPS() .. ")",
                0, textYpos
            )

            love.graphics.setColor(1, 0, 0, 1)
            local helthTxt = "Helth(" .. helth .. ")"
            love.graphics.print(
                helthTxt,
                (UIRect.width / 2) - (font:getWidth(helthTxt) / 2), textYpos
            )

            love.graphics.setColor(0, 1, 0, 1)
            local scoreTxt = "Score(" .. score .. ")"
            love.graphics.print(
                scoreTxt,
                (UIRect.width) - (font:getWidth(scoreTxt)), textYpos
            )
        end
    end
end

function game.exit(love) -- On when game is not played (game state is not playing game)
end

function game.quit(love) -- On exit of the app itself
end

return game