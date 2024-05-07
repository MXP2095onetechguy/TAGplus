local credits = {} -- Exports table

local exitRequester -- Method for exiting -> function(newState)

local DOCSBTN = {} -- Button for docs
local EXITBTN = {} -- Button for exiting the screen

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
    
    do -- Create buttons
        local sw = love.graphics.getWidth()
        local sh = love.graphics.getHeight()
        local height = 30

        DOCSBTN = {}
        DOCSBTN.color = {
            r = 0,
            g = 0,
            b = 0.5,
            a = 1
        }
        DOCSBTN.msgColor = {
            r = 1,
            g = 1,
            b = 1,
            a = 1
        }
        DOCSBTN.x = 0
        DOCSBTN.msg = "Docs"
        DOCSBTN.height = height
        DOCSBTN.y = sh - height
        DOCSBTN.width = sw/2

        EXITBTN = {}
        EXITBTN.color = {
            r = 1,
            g = 0,
            b = 0,
            a = 1
        }
        EXITBTN.msgColor = {
            r = 1,
            g = 1,
            b = 1,
            a = 1
        }
        EXITBTN.x = DOCSBTN.x + DOCSBTN.width
        EXITBTN.msg = "Go back"
        EXITBTN.height = height
        EXITBTN.y = sh - height
        EXITBTN.width = sw/2
    end
end

function credits.update(love, dt) -- Update things
end

function credits.draw(love) -- Draw
    love.graphics.setColor(0, 0, 0, 1) -- Paint text
    love.graphics.print("Credits!", 0, 0)

    do -- Credits things actually
        local font = love.graphics.getFont()
        love.graphics.setColor(0, 0, 0, 1)

        local txt = 
[[
This game was built with Love2D by MXPSQL.
MXPSQL aka MXPSQL Server 20953 Onetechguy.

The Apul Game+ - MXPSQL Server 20953 Onetechguy (2024) - MIT License
The Apul Game - Jane Doe (2024) - CC0 1.0
Love2D - Love Development Team (2006-2024) - Zlib License
Handlee Font - Joe Prince, Vissol (2011) - SIL Open Font License
Dotenv - kooshie (2023) - MIT License
Classy - Philipp Janda (2013-2014) - MIT License
]]

        love.graphics.print(txt, 
            (love.graphics.getWidth()/2) - (font:getWidth(txt)/2),
            (love.graphics.getHeight()/2) - (font:getHeight(txt)/2)
        )
    end

    do -- Draw buttons
        local font = love.graphics.getFont()

        do -- Docs button
            love.graphics.setColor(DOCSBTN.color.r, DOCSBTN.color.g, DOCSBTN.color.b, DOCSBTN.color.a)
            love.graphics.rectangle("fill", DOCSBTN.x, DOCSBTN.y, DOCSBTN.width, DOCSBTN.height)
            love.graphics.setColor(DOCSBTN.msgColor.r, DOCSBTN.msgColor.g, DOCSBTN.msgColor.b, DOCSBTN.msgColor.a)
            love.graphics.print(DOCSBTN.msg, 
                (DOCSBTN.x + (DOCSBTN.width/2)) - font:getWidth(DOCSBTN.msg), 
                (DOCSBTN.y + DOCSBTN.height) - font:getHeight(DOCSBTN.msg)
            )
        end

        do -- Exit button
            love.graphics.setColor(EXITBTN.color.r, EXITBTN.color.g, EXITBTN.color.b, EXITBTN.color.a)
            love.graphics.rectangle("fill", EXITBTN.x, EXITBTN.y, EXITBTN.width, EXITBTN.height)
            love.graphics.setColor(EXITBTN.msgColor.r, EXITBTN.msgColor.g, EXITBTN.msgColor.b, EXITBTN.msgColor.a)
            love.graphics.print(EXITBTN.msg, 
                (EXITBTN.x + (EXITBTN.width/2)) - font:getWidth(EXITBTN.msg), 
                (EXITBTN.y + EXITBTN.height) - font:getHeight(EXITBTN.msg)
            )
        end
    end
end

function credits.mousepressed(x, y, btn, _)
    if inBoxRange(x, y, DOCSBTN.x, DOCSBTN.y, DOCSBTN.width, DOCSBTN.height) then
        love.window.showMessageBox("Docs", docs, "info", true)
    end
    if inBoxRange(x, y, EXITBTN.x, EXITBTN.y, EXITBTN.width, EXITBTN.height) then -- Exit button
        exitRequester("HOME")
    end
end

return credits