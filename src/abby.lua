local classy = require("libs/class/classy") -- Import class lib

local Abby = classy("Abby") -- Create ze class for exports

function Abby:__init(love, world)
    self.image = love.graphics.newImage("assets/image/abby.png") -- Load Abby image

    self.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "dynamic") -- Create a body for Abby
    self.shape = love.physics.newRectangleShape(self.image:getWidth(), self.image:getHeight()) -- Attach shape for Abby
    self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- Create fixture for Abby's body and shape to join


    self.fixture:setUserData("Abby") -- Set user data
    self.body:setFixedRotation(true) -- Setup body to prevent rotation
    self.fixture:setRestitution(0.7) -- Setup bounciness or restitution
end

function Abby:update(love, dt) -- Update Abby
    self.body:setAwake(true)
end

function Abby:draw(love) -- Paint Abby
    love.graphics.setColor(1, 1, 1, 1) -- White for all color
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), 0.5, 0.5) -- Paint graphics
end

function Abby:tp(x, y)
    self.body:setLinearVelocity(0, 0)
    self.body:setX(x)
    self.body:setY(y)
end

return Abby