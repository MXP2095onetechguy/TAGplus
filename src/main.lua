-- Import libraries
local libOnce = require("libs/once") -- Import libOnce for call once things

-- Import logic
local game = require("game") -- Import the game logic
local home = require("home") -- Import the home screen logic

-- Game things
local isGameSleeping = false -- A flag used for checking if the game should sleep or not. This could be used as a pause.
local gameState = "HOME" -- "HOME", "GAME", "DED" for game state.
local gameLoaded = libOnce.initFlag() -- A flag to call the load method of game only once until reset when going back to non game states
local gameExited = libOnce.initFlag() -- A flag to reset some things of the game only once until reset when going to game states
local bgColor = {0.7, 0.9, 1}


-- Install some listeners and things
function love.focus(focus) -- Handle window focus
    isGameSleeping = not focus -- Sleep the game if not in focus
    if gameState == "GAME" then game.focus(love, focus) end
end


-- Game lifecycle: Initializing loading, Update, Painting and Quitting
function love.load() -- Load some assets and things
    love.graphics.setBackgroundColor(bgColor) -- Set a background color
    love.graphics.setNewFont("assets/font/Handlee.ttf", 18) -- Load a new font

    -- Eagerly load home screen
    home.load(love)
end

function love.update(dt) -- Perform updates
    if isGameSleeping then return end -- Sleep the game if paused
    if gameState == "GAME" then -- Do game things if the gameState is GAME.
        gameExited = libOnce.initFlag()
        libOnce.call(gameLoaded, game.load, love, true, function(state) gameState = state end) -- Only call the load method once
        game.update(love, dt) -- Update the game
    else
        gameLoaded = libOnce.initFlag()
        libOnce.call(gameExited, game.exit)
        if gameState == "HOME" then
            home.update(love, dt)
        elseif gameState == "DED" then
        else
            error("Game state is in an invalid state!")
        end
    end
end

function love.mousepressed(x, y, btn, istouch)
    if isGameSleeping then return end -- Sleep the game if paused
    if gameState == "GAME" then game.mousepressed(x, y, btn, istouch)
    elseif gameState == "HOME" then gameState = "GAME" end
end

function love.draw() -- Draw graphics and things
    love.graphics.clear(bgColor) -- Set a background color

    if isGameSleeping then -- Sleep the game if paused
        local sleepTxt = "Game is sleeping. Its on pause right now.\nFocus the window again to awaken it again.\nWe do this to conserve resources." -- Message we want to display.
        local font = love.graphics.getFont()
        love.graphics.setColor(0, 0, 0, 1) -- Set color to black
        love.graphics.print(sleepTxt, (love.graphics.getWidth()/2) - (font:getWidth(sleepTxt)/2), (love.graphics.getHeight()/2) - (font:getHeight(sleepTxt))) -- Display at the center
        return 
    end
    if gameState == "GAME" then game.draw(love) 
    elseif gameState == "HOME" then home.draw(love) end -- Draw the game
end

function love.quit() -- Handle some quit
    game.quit() -- Quite on the game
end