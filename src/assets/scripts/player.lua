local Class = require 'libs/classic'
local Vector = require 'libs/vector'
local Animation = require 'assets/scripts/animation'

local Player = Class:extend()

function Player:new(x, y, sprites)
    self.pos = Vector(x, y)
    self.velocity = Vector(0, 0)

    self.jumpForce = 600
    self.gravity = 3500

    self.isGrounded = true

    self.state = 'idle'

    self.sprites = {}
    self.sprites.crouch = Animation(love.graphics.newImage(sprites .. 'crouch.png'), 2, 0.5)
    self.sprites.dead = Animation(love.graphics.newImage(sprites .. 'dead.png'), 1, 1)
    self.sprites.idle = Animation(love.graphics.newImage(sprites .. 'idle.png'), 1, 1)
    self.sprites.jump = Animation(love.graphics.newImage(sprites .. 'jump.png'), 1, 1)
    self.sprites.walk = Animation(love.graphics.newImage(sprites .. 'walk.png'), 2, 0.5)

    self.crouchHeight = self.sprites.walk:getSize().y - self.sprites.crouch:getSize().y

    self.currentSprite = self.sprites[self.state]
    self.hitbox = self.currentSprite:getSize()
end

function Player:update(dt)
    self.currentSprite = self.sprites[self.state]
    self.currentSprite:update(dt)

    self.hitbox = self.currentSprite:getSize()

    if player.state == 'dead' or game.state == 'over' then
        return
    end

    self:move(dt)
    self:checkGround()

    if game.state == 'running' then
        -- Apply gravity
        self.velocity.y = self.velocity.y + self.gravity * dt
    end

    -- Move the player
    self.pos = self.pos + self.velocity * dt
end

function Player:move(dt)
    if game.state == 'idle' then
        if love.keyboard.isDown('space') or love.keyboard.isDown('up') then
            game.state = 'running'
            self.state = 'walk'
        end
        return
    end

    if self.isGrounded then
        self.state = 'walk'
    end

    if love.keyboard.isDown('down') and self.isGrounded then
        self.state = 'crouch'
        self.pos.y = self.pos.y + self.crouchHeight
    elseif love.keyboard.isDown('down') and not self.isGrounded then
        self.velocity.y = self.velocity.y + self.gravity * dt
    elseif (love.keyboard.isDown('space') or love.keyboard.isDown('up')) and self.isGrounded then
        self.velocity.y = self.velocity.y - self.jumpForce
        self.isGrounded = false
        self.state = 'jump'
    end
end

function Player:checkGround()
    -- Check for collision with the ground
    if self.pos.y + self.hitbox.y >= 500 then
        self.pos.y = 500 - self.hitbox.y
        self.isGrounded = true

        if self.state ~= 'jump' then
            self.velocity.y = 0
        end
    end
end

function Player:die()
    self.state = 'dead'
    game.state = 'over'
    debug = true
end

function Player:draw()
    self.currentSprite:draw(self.pos.x, self.pos.y)

    if debug then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle('line', self.pos.x, self.pos.y, self.hitbox.x, self.hitbox.y)

        love.graphics.print('vy: ' .. string.format("%.2f", self.velocity.y), self.pos.x, self.pos.y - 15)
        love.graphics.print('state: ' .. self.state, self.pos.x, self.pos.y - 30)
        love.graphics.setColor(1, 1, 1)
    end
end

return Player