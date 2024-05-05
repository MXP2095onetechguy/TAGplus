local game = {} -- A table for exporting the methods

-- Import game objects
local abby = require("abby") -- Import the main player/Abby
local dmkid = require("dmkid") -- Import the enemy/D-Money kid

local gameConf = {} -- Get config for game

-- CONSTANTS
local NORM_MAX_HELTH = 10 -- Maximum helth for normal mode
local TURB_MAX_HELTH = 5 -- Maximum helth for turb mode/hard mode

local NORM_BGM_PITCH = 1 -- BGM Pitch for normal mode
local TURB_BGM_PITCH = 1.24 -- BGM Pitch for turb mode/hard mode

-- Game Info Thingys
local font = nil
local UIRect = {}
local bgmSource = nil

-- Game states
local score = 0 -- Score
local helth = NORM_MAX_HELTH -- Helth
local turbMode = false -- Turb mode setting/Hard mode enabled?
local exitRequester = nil -- A callback that is invoked when the game requests an exit to a new gameState -> function(newState)

-- Game objects
local world = nil -- Physics world
local worldBorder = {} -- World border for the physics world
local player = nil -- Player

function game.focus(love, focus) -- Focus handler
    do -- Music playback focus check
        if bgmSource then -- BGM Source nil check
            if focus then -- Check focus for music playback
                bgmSource:play() -- In focus? play
            else
                bgmSource:pause() -- Not in focus? pause
            end
        end
    end
end

function game.load(love, turb, exitrequester) -- Onload game
    -- Setup turb mode
    turbMode = turb

    -- Setup exitRequester
    exitRequester = exitrequester

    -- Set up vars
    do -- Setup helth
        local helf = (turbMode and {TURB_MAX_HELTH} or {NORM_MAX_HELTH})[1] -- Get helth from current mode
        helth = helf -- Set helth
    end

    do -- A block of code for getting Love2D configuration if needed
        local libConf = require("conf")
        libConf.fillConf(gameConf)
        libConf.getConf(gameConf)
    end

    -- Get font
    font = love.graphics.getFont()

    -- Setup BGM
    bgmSource = love.audio.newSource("assets/audio/bgm.ogg", "stream")

    do -- Setup physics
        local meterPx = 64
        love.physics.setMeter(meterPx)
        world = love.physics.newWorld(0, 9.81*meterPx, true)
    end

    do -- Set up the UI-Layered UI Rect
        UIRect.x = 0
        UIRect.height = 30
        UIRect.y = love.graphics.getHeight() - UIRect.height
        UIRect.width = love.graphics.getWidth()
    end

    do -- Setup world border
        local UIGround = {} -- The ground AKA the UI Rect aka the Bottom Wall.
        UIGround.body = love.physics.newBody(world, UIRect.width/2, love.graphics.getHeight()-(UIRect.height/2))
        UIGround.shape = love.physics.newRectangleShape(UIRect.width, UIRect.height)
        UIGround.fixture = love.physics.newFixture(UIGround.body, UIGround.shape)

        worldBorder.UIGround = UIGround
    end



    -- Play BGM
    do
        local pitch = (turbMode and {TURB_BGM_PITCH} or {NORM_BGM_PITCH})[1] -- Get pitch from mode
        bgmSource:setPitch(pitch) -- Set pitch depending on TurbMode
        bgmSource:setLooping(true) -- set Looping for BGM
        bgmSource:play() -- Play the BGM
    end
end

function game.update(love, dt) -- Update game
    world:update(dt)
end

function game.draw(love) -- Paint the game
    do -- Painting the gameObjects
        do -- Paint the worldborder, mostly for debug purposes
            local wb = worldBorder -- An alias for the World Border
            local uig = wb.UIGround -- An alias for the Ground.
            love.graphics.setColor(0.28, 0.63, 0.05)
            love.graphics.polygon("fill", uig.body:getWorldPoints(uig.shape:getPoints()))
        end
    end

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
    if bgmSource then bgmSource:stop() end -- Stop music on exit
end

function game.mousepressed(x, y, button, _) -- Handle mouse clicks, for the player
end

function game.quit(love) -- On exit of the app itself
end

return game