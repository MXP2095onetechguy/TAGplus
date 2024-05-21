local classy = require("libs/class/classy")

local items = classy("Items")

function items:__init(love, world, itype)
    self.image = love.graphics.newImage("assets/image/" .. itype .. ".png") -- Load items image

    self.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "dynamic") -- Create a body for items
    self.shape = love.physics.newRectangleShape(self.image:getWidth(), self.image:getHeight()) -- Attach shape for items
    self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- Create fixture for items's body and shape to join


    self.fixture:setUserData("Items:" .. itype) -- Set user data
    self.body:setFixedRotation(true) -- Setup body to prevent rotation
    self.fixture:setRestitution(0.7) -- Setup bounciness or restitution
end

function items:update(love, dt) -- Update items
    self.body:setAwake(true)
end

function items:draw(love) -- Paint items
    love.graphics.setColor(1, 1, 1, 1) -- White for all color
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), 0.5, 0.5) -- Paint graphics
end

function items:tp(x, y)
    self.body:setLinearVelocity(0, 0)
    self.body:setX(x)
    self.body:setY(y)
end

function items:destroy()
    self.fixture:destroy()
end

return items