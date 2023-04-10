local Class = require 'libs/classic'
local Vector = require 'libs/vector'

local Background = Class:extend()

function Background:new(path)
    self.floors = {}

    for i = 1, 2 do
        local floor = {}
        floor.image = love.graphics.newImage(path .. 'floor.png')
        floor.width = floor.image:getWidth()
        floor.height = floor.image:getHeight()
        floor.pos = Vector((i - 1) * floor.width, love.graphics.getHeight() - floor.height)

        table.insert(self.floors, floor)
    end

    self.clouds = {}
    local number_of_clouds = 4

    for i = 1, number_of_clouds do
        local cloud = {}
        cloud.image = love.graphics.newImage(path .. 'cloud.png')
        cloud.width = cloud.image:getWidth()
        cloud.height = cloud.image:getHeight()

        -- Randomize the position of the clouds
        local cloud_distance = love.graphics.getWidth() / number_of_clouds
        cloud.pos = Vector((i - 1) * cloud_distance, math.random(0, love.graphics.getHeight() * 2 / 3))

        table.insert(self.clouds, cloud)
    end
end

function Background:update(dt)
    -- Move the floors to the left at the speed of the game
    for i, floor in ipairs(self.floors) do
        floor.pos.x = floor.pos.x - game.speed * dt

        -- If the floor is out of the screen, move it to the right
        if floor.pos.x + floor.width < 0 then
            floor.pos.x = floor.pos.x + 2 * floor.width
        end
    end

    -- Move the clouds to the left at a slower speed than the game (to create a parallax effect)
    for i, cloud in ipairs(self.clouds) do
        cloud.pos.x = cloud.pos.x - game.speed / 4 * dt

        -- If the cloud is out of the screen, move it to the right
        if cloud.pos.x + cloud.width < 0 then
            cloud.pos.x = love.graphics.getWidth()
        end
    end
end

function Background:draw()
    for _, floor in ipairs(self.floors) do
        love.graphics.draw(floor.image, floor.pos.x, floor.pos.y)
    end

    for _, cloud in ipairs(self.clouds) do
        love.graphics.draw(cloud.image, cloud.pos.x, cloud.pos.y)
    end
end

return Background