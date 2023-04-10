local Class = require 'libs/classic'
local Vector = require 'libs/vector'

local Animation = Class:extend()

function Animation:new(spritesheet, frames, duration)
    self.spritesheet = spritesheet
    self.frames = frames
    self.duration = duration
    self.timer = 0
    self.quad = love.graphics.newQuad(0, 0, self.spritesheet:getWidth() / self.frames, self.spritesheet:getHeight(),
    self.spritesheet:getDimensions())
end

function Animation:getSize()
    return Vector(self.spritesheet:getWidth() / self.frames, self.spritesheet:getHeight())
end

function Animation:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.duration then
        self.timer = self.timer - self.duration
    end
    local frame = math.floor(self.timer / self.duration * self.frames) + 1
    self.quad:setViewport((frame - 1) * self.spritesheet:getWidth() / self.frames, 0,
    self.spritesheet:getWidth() / self.frames, self.spritesheet:getHeight())
end

function Animation:draw(x, y)
    love.graphics.draw(self.spritesheet, self.quad, x, y, 0, 1, 1, 0, 0, 0, 0)
end

return Animation