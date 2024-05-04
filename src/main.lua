-- Import libraries
local libOnce = require("libs/once")

-- Import logic
local game = require("game")

-- Game things
local isGameSleeping = false -- A flag used for checking if the game should sleep or not. This could be used as a pause.
local gameState = "GAME" -- "HOME", "GAME", "DED" for game state.
local gameLoaded = libOnce.initFlag() -- A flag to call the load method of game only once
local bgColor = {0.7, 0.9, 1}


-- Install some listeners and things
function love.focus(focus) -- Handle window focus
    isGameSleeping = not focus -- Sleep the game if not in focus
end


-- Game lifecycle: Initializing loading, Update, Painting and Quitting
function love.load() -- Load some assets and things
    love.graphics.setBackgroundColor(bgColor) -- Set a background color
    love.graphics.setNewFont("assets/font/Handlee.ttf", 18) -- Load a new font
end

function love.update(dt) -- Perform updates
    if isGameSleeping then return end -- Sleep the game if paused
    if gameState == "GAME" then -- Do game things if the gameState is GAME.
        libOnce.call(gameLoaded, game.load, love) -- Only call the load method once
        game.update(love, dt) -- Update the game
    end
end

function love.draw() -- Draw graphics and things
    love.graphics.clear(bgColor)
    if gameState == "GAME" then game.draw(love) end -- Draw the game
end

function love.quit() -- Handle some quit
    game.quit()
end