local jukebox = {} -- Table for exports

local consts = require("consts") -- Import constants

-- Jukebox state
local exitRequester = nil -- Method for exiting -> function(newState)
local bgmSource = nil -- A reference to the BGM for jukebox purposes
local turbState = nil -- A state for the turbMode used for rendering

-- World graphics state
local world = nil -- A fun world for fun graphics!
local ball = {} -- A little ball
local ground = {} -- A ground for the ball


function jukebox.load(love, exitrequester, bgm, turbMode)
    exitRequester = exitrequester -- Exitrequester
    bgmSource = bgm -- Get BGM

    turbState = turbMode -- Set turb state
    bgm:setPitch((turbState and {consts.TURB_BGM_PITCH} or {consts.NORM_BGM_PITCH})[1]) -- Set pitch
    bgm:setLooping(true)
    bgm:play() -- Play

    do -- Setup a physics world
        local meterPx = 64 -- Meter pixels
        love.physics.setMeter(meterPx) -- Meter setup
        world = love.physics.newWorld(0, 9.81*meterPx, true) -- Create world

        ball.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "dynamic") -- Create ball
        ball.shape = love.physics.newCircleShape(20) -- Create ball 2
        ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1) -- Combine ball shape with body to make ball
        ball.fixture:setRestitution(1) -- Make ball bouncy

        ground.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight(), "static")
        ground.shape = love.physics.newRectangleShape(love.graphics.getWidth(), 50)
        ground.fixture = love.physics.newFixture(ground.body, ground.shape)
    end
end

function jukebox.update(love, dt)
    world:update(dt) -- Make physics happen
end

function jukebox.draw(love)
    do -- You are in the jukebox message
        love.graphics.setColor(0, 0, 0, 1) -- Paint black
        local msg = "You are in the jukebox rn.\nEnjoy the music stress-free!\nClick anywhere to exit and return."
        local font = love.graphics.getFont() -- Get font for positions
        local x = (love.graphics.getWidth()/2) - font:getWidth(msg) -- Position x
        local y = (love.graphics.getHeight()/4) - font:getHeight(msg) -- Position y
        love.graphics.print(msg, x, y) -- Print the message
    end

    do -- Render physics graphics
        love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
        love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints())) -- Render the ground

        love.graphics.setColor(0.76, 0.18, 0.05) --set the drawing color to red for the ball
        love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius()) -- Render ball
    end

    do -- Render turb state
        if turbState then
            love.graphics.push()
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.print("TURB TIME!", love.graphics.getWidth()/2, (love.graphics.getHeight()/2))
            love.graphics.pop()
        end
    end
end

function jukebox.mousepressed(x, y, btn, _)
    exitRequester("HOME") -- Exit by clicking anywhere
end

function jukebox.exit(love)
    if bgmSource then -- Stop bgm playback
        bgmSource:stop()
    end
end

return jukebox