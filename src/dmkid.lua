local classy = require("libs/class/classy")

local classy = require("libs/class/classy") -- Import class lib

local dmKid = classy("dmKid") -- Create ze class for exports

function dmKid:__init(love, world)
    self.image = love.graphics.newImage("assets/image/dmkid.png") -- Load dmKid image

    self.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "dynamic") -- Create a body for dmKid
    self.shape = love.physics.newRectangleShape(self.image:getWidth(), self.image:getHeight()) -- Attach shape for dmKid
    self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- Create fixture for dmKid's body and shape to join

    self.body:setFixedRotation(true) -- Setup body to prevent rotation
    self.fixture:setRestitution(1)

    self.fixture:setUserData("dmKid")
end

function dmKid:update(love, dt) -- Update dmKid
    self.body:setAwake(true)
end

function dmKid:draw(love) -- Paint dmKid
    love.graphics.setColor(1, 1, 1, 1) -- White for all color
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), 0.5, 0.5) -- Paint graphics
end

function dmKid:tp(x, y)
    self.body:setLinearVelocity(0, 0)
    self.body:setX(x)
    self.body:setY(y)
end

function dmKid:ping(leftping)
    if leftping then
        self.body:setLinearVelocity(-400, 0)
    else
        self.body:setLinearVelocity(400, 0)
    end
end

function dmKid:destroy()
    self.fixture:destroy()
end

return dmKid