local jukebox = {} -- Table for exports

local consts = require("consts") -- Import constants

local exitRequester = nil -- Method for exiting -> function(newState)
local bgmSource = nil -- A reference to the BGM for jukebox purposes
local turbState = nil -- A state for the turbMode used for rendering

function jukebox.load(love, exitrequester, bgm, turbMode)
    exitRequester = exitrequester -- Exitrequester
    bgmSource = bgm -- Get BGM

    turbState = turbMode -- Set turb state
    bgm:setPitch((turbState and {consts.TURB_BGM_PITCH} or {consts.NORM_BGM_PITCH})[1]) -- Set pitch
    bgm:setLooping(true)
    bgm:play() -- Play
end

function jukebox.update(love, dt)
    -- Nothing to see here
end

function jukebox.draw(love)
    do -- You are in the jukebox message
        love.graphics.setColor(0, 0, 0, 1) -- Paint black
        local msg = "You are in the jukebox rn.\nClick anywhere to exit."
        local font = love.graphics.getFont() -- Get font for positions
        local x = (love.graphics.getWidth()/2) - font:getWidth(msg) -- Position x
        local y = (love.graphics.getHeight()/4) - font:getHeight(msg) -- Position y
        love.graphics.print(msg, x, y) -- Print the message
    end

    do -- Render turb state
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