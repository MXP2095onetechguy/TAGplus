local ded = {} -- Exports table

local exitRequester -- Method for exiting -> function(newState)


function ded.load(love, erq) -- Load
    -- Setup exit Requester
    exitRequester = erq
end

function ded.update(love, dt) -- Update things
end

function ded.draw(love) -- Draw
    love.graphics.setColor(0, 0, 0, 1) -- Paint text (LAZY)
    love.graphics.print("U R Ded!", 0, 0)
    love.graphics.print("Click anywhere to go to home screen", 0, 20)
end

function ded.mousepressed(x, y, btn, _)
    exitRequester("HOME")
end

return ded