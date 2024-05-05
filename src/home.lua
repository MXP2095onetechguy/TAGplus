local home = {} -- A table for exporting the methods

function home.load(love)
end

function home.update(love, dt)
end

function home.draw(love)
    love.graphics.print("HOME", 0, 0)
end

return home