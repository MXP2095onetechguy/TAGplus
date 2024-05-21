-- Import libraries
local libOnce = require("libs/once") -- Import libOnce for call once things
local denv = require("libs/denv") -- Import dotenv for config

-- Import logic
local game = require("game") -- Import the game logic
local home = require("home") -- Import the home screen logic
local jukebox = require("jukebox") -- Import the Jukebox logic
local credits = require("credits") -- Import the credits and documentation logic
local ded = require("ded") -- Import the game over screen logic

-- App things
local isGameSleeping = false -- A flag used for checking if the game should sleep or not. This could be used as a pause.
local turbMode = true -- Bool specifying turb mode
local gameState = "HOME" -- "HOME", "JUKEBOX", "GAME", "CREDITS", "DED" for game state.
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
function love.load(args) -- Load some assets and things
    local classicBGM = false -- Variable to set the classic BGM instead of the new BGM. eventually, this can be set by the player.
    local envfile = nil -- Path to .env file for config

    do -- Actual Args Parsin'
        for pos, arg in ipairs(args) do -- Parse args into two variables: pos for position and args for the arguments themselkves
            if arg == "--config" or arg == "-c" then --Config file
                if args[pos+1] then
                    envfile = args[pos+1]
                else
                    error("Missing file argument to " .. arg)
                end
            end
        end
    end

    if envfile then -- Load some config as .env
        local envPairs, err = denv.load(envfile)
        if envPairs then -- Check if loaded
            do -- Classic BGM mode parsin'
                local classicBGMEnv = envPairs["CLASSICBGM"] -- Get dotenv

                if classicBGMEnv == nil or not classicBGMEnv then -- Handle empty case
                    classicBGMEnv = ""
                end

                classicBGMEnv = string.match(classicBGMEnv, "^%s*(.-)%s*$") -- String trim
                classicBGMEnv = string.lower(classicBGMEnv) -- String lowering
                
                if -- Actually check for true
                    classicBGMEnv == "true" or -- Inverse -> false
                    classicBGMEnv == "tru" or -- Inverse -> fals
                    classicBGMEnv == "sure" -- Inverse -> nah
                then
                    classicBGM = true
                else 
                    classicBGM = false
                end
            end
        else
            love.window.showMessageBox("Config Error!", 
                "File '" .. envfile .. "' seems to have a problem with opening. \n" ..
                "Config file will not be loaded, and game will proceed with defaults. \n" ..
                "More specific error message: \n '" .. err .. "'",
                "warning",
                true
            )
        end
    end

    love.graphics.setBackgroundColor(bgColor) -- Set a background color
    love.graphics.setNewFont("assets/font/Handlee.ttf", 18) -- Load a new font

    -- Eagerly load the BGM
    bgmSourceMusic = love.audio.newSource("assets/audio/" .. ((classicBGM and {"classic"} or {""})[1]) .. "bgm.ogg", "stream")

    -- Eagerly load home screen
    home.load(love, function(state, turbmode)
        turbMode = turbmode
        gameState = state
    end)

    -- Eagerly load credit screen
    credits.load(love, function(state) gameState = state end)
    -- Eagerly load the game over screen
    ded.load(love, function(state) gameState = state end)

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
        ded.update(love, dt)
    else
    end

    if gameState == "CREDITS" then
        credits.update(love, dt)
    end
end

function love.mousepressed(x, y, btn, istouch)
    if isGameSleeping then return end -- Sleep the game if paused
    if gameState == "GAME" then game.mousepressed(x, y, btn, istouch)
    elseif gameState == "HOME" then home.mousepressed(x, y, btn, istouch) 
    elseif gameState == "JUKEBOX" then jukebox.mousepressed(x, y, btn, istouch)
    elseif gameState == "CREDITS" then credits.mousepressed(x, y, btn, istouch) 
    elseif gameState == "DED" then ded.mousepressed(x, y, btn, istouch) end
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
    elseif gameState == "JUKEBOX" then jukebox.draw(love) 
    elseif gameState == "CREDITS" then credits.draw(love) 
    elseif gameState == "DED" then ded.draw(love) end -- Draw the game
end

function love.wheelmoved(x, y)
    if gameState == "CREDITS" then credits.wheelmoved(x, y) end
end

function love.quit() -- Handle some quit
    game.quit() -- Quite on the game
    return false
end