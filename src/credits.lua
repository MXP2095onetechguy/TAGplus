local credits = {} -- Exports table

local exitRequester -- Method for exiting -> function(newState)

function inBoxRange(mx, my, rx, ry, rw, rh) -- A function used to check if mouse x and mouse y is in box?
    if (mx >= rx and mx <= (rx+rw)) then
        if my >= ry and my <= (ry+rh) then
            return true
        end
    end
    return false
end

local docs = "docs.txt"


function credits.load(love, erq) -- Load
    exitRequester = erq
    docs = love.filesystem.read(docs)
    assert(docs)
    print(docs)
end

function credits.update(love, dt) -- Update things
end

function credits.draw(love) -- Draw
    love.graphics.print("Credits!", 0, 0)
end

function credits.mousepressed(x, y, btn, _)
    exitRequester("HOME")
end

return credits