local game = {} -- A table for exporting the methods

-- Import constants
local consts = require("consts")

-- Import cron for spawning
local cron = require("libs/cron")

-- Import game objects
local abby = require("abby") -- Import the main player/Abby
local dmkid = require("dmkid") -- Import the enemy/D-Money kid
local item = require("items") -- Import the items

local gameConf = {} -- Get config for game

-- Game Info Thingys
local font = nil
local UIRect = {}
local bgmSource = nil

-- Game states
local score = 0 -- Score
local helth = consts.NORM_MAX_HELTH -- Helth
local turbMode = false -- Turb mode setting/Hard mode enabled?
local exitRequester = nil -- A callback that is invoked when the game requests an exit to a new gameState -> function(newState)

-- Game objects
local world = nil -- Physics world
local worldBorder = {} -- World border for the physics world
local player = nil -- Player
local dmKidSpawner = cron.every(2, function() spawnDmKid() end) -- Spawner
local itemSpawner = cron.every(4, function() spawnItems() end) -- Spawner
local dmKids = {} -- DMKids
local items = {} -- Items that are dropped

function game.focus(love, focus) -- Focus handler
    do -- Music playback focus check
        if bgmSource then -- BGM Source nil check
            if focus then -- Check focus for music playback
                bgmSource:play() -- In focus? play
            else
                bgmSource:pause() -- Not in focus? pause
            end
        end
    end
end

function game.load(love, turb, bgmsrc, exitrequester) -- Onload game
    -- Setup turb mode
    turbMode = turb

    -- Setup exitRequester
    exitRequester = exitrequester

    -- Set up vars
    do -- Setup helth
        local helf = (turbMode and {consts.TURB_MAX_HELTH} or {consts.NORM_MAX_HELTH})[1] -- Get helth from current mode
        helth = helf -- Set helth
    end

    do -- A block of code for getting Love2D configuration if needed
        local libConf = require("conf")
        libConf.fillConf(gameConf)
        libConf.getConf(gameConf)
    end

    -- Get font
    font = love.graphics.getFont()

    -- Setup BGM
    bgmSource = bgmsrc

    do -- Setup physics
        local meterPx = 64
        love.physics.setMeter(meterPx)
        world = love.physics.newWorld(0, 9.81*meterPx, true)
        world:setCallbacks(worldCollisionCallback, nil, nil, nil)
    end

    do -- Set up the UI-Layered UI Rect
        UIRect.x = 0
        UIRect.height = 30
        UIRect.y = love.graphics.getHeight() - UIRect.height
        UIRect.width = love.graphics.getWidth()
    end

    do -- Setup world border
        local UIGround = {} -- The ground AKA the UI Rect aka the Bottom Wall.
        UIGround.body = love.physics.newBody(world, UIRect.width/2, love.graphics.getHeight()-(UIRect.height/2), "static")
        UIGround.shape = love.physics.newRectangleShape(UIRect.width, UIRect.height)
        UIGround.fixture = love.physics.newFixture(UIGround.body, UIGround.shape)

        local leftWall = {}
        leftWall.body = love.physics.newBody(world, (UIRect.height * -1)/2, love.graphics.getHeight()/2, "static")
        leftWall.shape = love.physics.newRectangleShape(UIRect.height, love.graphics.getHeight())
        leftWall.fixture = love.physics.newFixture(leftWall.body, leftWall.shape)

        local rightWall = {}
        rightWall.body = love.physics.newBody(world, (UIRect.height/2) + love.graphics.getWidth(), love.graphics.getHeight()/2, "static")
        rightWall.shape = love.physics.newRectangleShape(UIRect.height, love.graphics.getHeight())
        rightWall.fixture = love.physics.newFixture(rightWall.body, rightWall.shape)

        local roof = {}
        roof.body = love.physics.newBody(world, UIRect.width/2, (UIRect.height * -1)/2, "static")
        roof.shape = love.physics.newRectangleShape(UIRect.width, UIRect.height)
        roof.fixture = love.physics.newFixture(roof.body, roof.shape)

        worldBorder.UIGround = UIGround
        worldBorder.leftWall = leftWall
        worldBorder.rightWall = rightWall
        worldBorder.roof = roof
    end

    do -- Setup player
        player = abby(love, world)
    end

    do -- Play BGM
        local pitch = (turbMode and {consts.TURB_BGM_PITCH} or {consts.NORM_BGM_PITCH})[1] -- Get pitch from mode
        bgmSource:setPitch(pitch) -- Set pitch depending on TurbMode
        bgmSource:setLooping(true) -- set Looping for BGM
        bgmSource:play() -- Play the BGM
    end

    do
        local i = item(love, world, "goldenapul")
        table.insert(items, i)
    end
end

function game.update(love, dt) -- Update game
    world:update(dt)

    player:update(love, dt)

    for i, k in pairs(dmKids) do
        k:update(love, dt)
    end

    for i, k in pairs(items) do
        k:update(love, dt)
    end

    dmKidSpawner:update(dt) -- Update the spawner
    itemSpawner:update(dt)
end

function game.draw(love) -- Paint the game
    do -- Painting the gameObjects
        do -- Paint the worldborder, mostly for debug purposes
            love.graphics.push() -- Push for this painting
            local wb = worldBorder -- An alias for the World Border
            local uig = wb.UIGround -- An alias for the Ground.
            local lw = wb.leftWall -- An alias for the left wall
            local rw = wb.rightWall -- An alias for the right wall
            local roof = wb.roof -- An alias for thr roof
            love.graphics.setColor(0.28, 0.63, 0.05, 1) -- Set color

            love.graphics.polygon("fill", uig.body:getWorldPoints(uig.shape:getPoints())) -- Paint ground/UIRect
            love.graphics.polygon("fill", lw.body:getWorldPoints(lw.shape:getPoints())) -- Paint left wall
            love.graphics.polygon("fill", rw.body:getWorldPoints(rw.shape:getPoints())) -- Paint right wall
            love.graphics.polygon("fill", roof.body:getWorldPoints(roof.shape:getPoints())) -- Paint the roof

            love.graphics.pop() -- Pop for default
        end

        player:draw(love) -- Paint Abby, the player

        -- Paint the dmKids
        for i, k in pairs(dmKids) do
            k:draw(love)
        end

        for i, k in pairs(items) do
            k:draw(love)
        end
    end

    do -- Painting Game UI
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", UIRect.x, UIRect.y, UIRect.width, UIRect.height)

        local textYpos = UIRect.y

        do -- Print text -> FPS, Lives, Score
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(
                "FPS(" .. love.timer.getFPS() .. ")",
                0, textYpos
            )

            love.graphics.setColor(1, 0, 0, 1)
            local helthTxt = "Helth(" .. helth .. ")"
            love.graphics.print(
                helthTxt,
                (UIRect.width / 2) - (font:getWidth(helthTxt) / 2), textYpos
            )

            love.graphics.setColor(0, 1, 0, 1)
            local scoreTxt = "Score(" .. score .. ")"
            love.graphics.print(
                scoreTxt,
                (UIRect.width) - (font:getWidth(scoreTxt)), textYpos
            )
        end

        if turbMode then -- Print Hard mode on top left
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.print("Turb Mode", 0, 0)
        end
    end

    if helth < 1 then
        exitRequester("DED")
    end
end

function game.exit(love) -- On when game is not played (game state is not playing game)
    if bgmSource then bgmSource:stop() end -- Stop music on exit
end

function game.mousepressed(x, y, button, _) -- Handle mouse clicks, for the player
    player:tp(x, y)
end

function game.quit(love) -- On exit of the app itself
end


function worldCollisionCallback(a, b, coll)
    local ua = a:getUserData()
    local ub = b:getUserData()
    --[[ 
        print("Collision - A(" .. 
        (ua and {ua} or {"nil"})[1]
        .. ") B(" .. 
        (ub and {ub} or {"nil"})[1]
        .. ")") 
    --]]

    for i, k in pairs(dmKids) do -- Handle dmKid attacks
        if (ua == "Abby" and k.fixture == b)
            or (k.fixture == a and ub == "Abby") then
            helth = helth - 1
            dmKids[i]:destroy()
            dmKids[i] = nil
        end
    end

    for i, k in pairs(items) do -- Handle items

        local itemtype = ""
        if (ua == "Abby" and k.fixture == b) then
            itemtype = ub
        elseif (k.fixture == a and ub == "Abby") then
            itemtype = ua
        end

        if string.match(itemtype, "goldenapul") then
            for i, k in pairs(dmKids) do -- Destroy all dmKids
                dmKids[i]:destroy()
                dmKids[i] = nil
            end
        elseif string.match(itemtype, "apul") then
            score = score + 1
        end

        items[i]:destroy()
        items[i] = nil
    end
end

function spawnDmKid()
    do
        local dmk = dmkid(love, world)
        dmk:tp(
            love.math.random(0, love.graphics.getWidth()),
            love.math.random(0, love.graphics.getHeight())
        )
        dmk:ping(
            (love.math.random(0, 1) and {true} or {false})[1]
        )
        table.insert(dmKids, dmk)
    end
end

function spawnItems()
    do
        local it = (love.math.random(0, 2) and {"golden"} or {""})[1] .. "apul"
        print(it)
        local im = item(love, world,
            it   
        )
        im:tp(
            love.math.random(0, love.graphics.getWidth()),
            love.math.random(0, love.graphics.getHeight())
        )
        table.insert(items, im)
    end
end

return game