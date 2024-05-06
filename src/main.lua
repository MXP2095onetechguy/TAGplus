-- Import libraries
local libOnce = require("libs/once") -- Import libOnce for call once things

-- Import logic
local game = require("game") -- Import the game logic
local home = require("home") -- Import the home screen logic
local jukebox = require("jukebox") -- Import the Jukebox logic

-- App things
local isGameSleeping = false -- A flag used for checking if the game should sleep or not. This could be used as a pause.
local turbMode = true -- Bool specifying turb mode
local gameState = "HOME" -- "HOME", "JUKEBOX", "GAME", "DED" for game state.
local gameLoaded = libOnce.initFlag() -- A flag to call the load method of game only once until reset when going back to non game states
local gameExited = libOnce.initFlag() -- A flag to reset some things of the game only once until reset when going to game states
local jukeboxLoaded = libOnce.initFlag() -- A flag to call the load method of the jukebox until reset like the gameLoaded flag.
local jukeboxExited = libOnce.initFlag() -- Serves like the gameExited flag, but for ze jukebox
local bgColor = {0.7, 0.9, 1} -- Color to the background
local bgmSourceMusic = nil -- Background music

-- Install some listeners and things
function love.focus(focus) -- Handle window focus
    isGameSleeping = not focus -- Sleep the game if not in focus
    if gameState == "GAME" then game.focus(love, focus) end
end


-- Game lifecycle: Initializing loading, Update, Painting and Quitting
function love.load() -- Load some assets and things
    love.graphics.setBackgroundColor(bgColor) -- Set a background color
    love.graphics.setNewFont("assets/font/Handlee.ttf", 18) -- Load a new font

    -- Eagerly load the BGM
    bgmSourceMusic = love.audio.newSource("assets/audio/bgm.ogg", "stream")

    -- Eagerly load home screen
    home.load(love, function(state, turbmode)
        turbMode = turbmode
        gameState = state
    end)
end

function love.update(dt) -- Perform updates
    if isGameSleeping then return end -- Sleep the game if paused

    if gameState == "GAME" then -- Do game things if the gameState is GAME.

        gameExited = libOnce.initFlag() -- Reset exit flag
        jukeboxLoaded = libOnce.initFlag() -- Reset jukebox flag
        libOnce.call(gameLoaded, game.load, love, turbMode, bgmSourceMusic, function(state) gameState = state end) -- Only call the load method once
        game.update(love, dt) -- Update the game

    else
        gameLoaded = libOnce.initFlag()
        libOnce.call(gameExited, game.exit) -- Exit game state
    end

    if gameState == "JUKEBOX" then -- Do jukebox things if the gameState is JUKEBOX
        jukeboxExited = libOnce.initFlag()

        libOnce.call(jukeboxLoaded, function()
            local turbOST = love.window.showMessageBox("Jukebox time!", "Would you like to hear the Turb mode version?", {"Yes", "No"}, "info", true) == 1
            jukebox.load(love, function(state)
                gameState = state
            end, bgmSourceMusic, turbOST)
        end) -- Load and intialize the jukebox
        
        jukebox.update(love, dt)
    else
        jukeboxLoaded = libOnce.initFlag()
        libOnce.call(jukeboxExited, jukebox.exit)
    end

    if gameState == "HOME" then -- Do homescreen things if the gameState is HOME
        home.update(love, dt) -- Update home page
    else
    end
    
    if gameState == "DED" then -- Do Game over things if the gameState is DED
    else
    end
end

function love.mousepressed(x, y, btn, istouch)
    if isGameSleeping then return end -- Sleep the game if paused
    if gameState == "GAME" then game.mousepressed(x, y, btn, istouch)
    elseif gameState == "HOME" then home.mousepressed(x, y, btn, istouch) 
    elseif gameState == "JUKEBOX" then jukebox.mousepressed(x, y, btn, istouch) end
end

function love.draw() -- Draw graphics and things
    love.graphics.clear(bgColor) -- Set a background color

    if isGameSleeping then -- Sleep the game if paused
        love.graphics.push() -- Push to preserve info
        local sleepTxt = "Game is sleeping. Its on pause right now.\nFocus the window again to awaken it again.\nWe do this to conserve resources." -- Message we want to display.
        local font = love.graphics.getFont()
        love.graphics.setColor(0, 0, 0, 1) -- Set color to black
        love.graphics.print(sleepTxt, (love.graphics.getWidth()/2) - (font:getWidth(sleepTxt)/2), (love.graphics.getHeight()/2) - (font:getHeight(sleepTxt))) -- Display at the center
        love.graphics.pop() -- Pop off the current state we have for the default
        return 
    end
    if gameState == "GAME" then game.draw(love) 
    elseif gameState == "HOME" then home.draw(love) 
    elseif gameState == "JUKEBOX" then jukebox.draw(love) end -- Draw the game
end

function love.quit() -- Handle some quit
    game.quit() -- Quite on the game
    return false
end