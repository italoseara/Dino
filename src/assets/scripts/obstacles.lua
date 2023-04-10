local Class = require 'libs/classic'
local Vector = require 'libs/vector'
local Animation = require 'assets/scripts/animation'

local Obstacles = Class:extend()

function Obstacles:new(path)
    self.obstacles = {}

    self.cactus = {}

    for i = 1, 6 do
        local cactus = {}
        -- cactus/1.png
        cactus.sprite = Animation(love.graphics.newImage(path .. 'cactus/' .. i .. '.png'), 1, 1)
        cactus.hitbox = cactus.sprite:getSize()

        table.insert(self.cactus, cactus)
    end

    self.bird = {}

    local bird = {}
    bird.sprite = Animation(love.graphics.newImage(path .. 'bird.png'), 2, 0.3)
    bird.hitbox = bird.sprite:getSize()

    table.insert(self.bird, bird)

    self.obstacle_distance = 700
end

function Obstacles:update(dt)
    self.obstacle_distance = self.obstacle_distance + math.random(-70, 70)

    -- Randomize the next obstacle
    local next_obstacle = "cactus"

    if math.random(1, 5) == 1 and game.speed > 800 then
        next_obstacle = 'bird'
    end

    -- Get the last obstacle
    local last_obstacle = self.obstacles[#self.obstacles]

    if last_obstacle == nil or last_obstacle.pos.x < love.graphics.getWidth() - self.obstacle_distance - last_obstacle.object.hitbox.x then
        self:generateObstacle(next_obstacle)
    end

    -- Move the obstacles to the left at the speed of the game
    for i, obstacle in ipairs(self.obstacles) do
        obstacle.pos.x = obstacle.pos.x - game.speed * dt

        -- If the obstacle is out of the screen, remove it
        if obstacle.pos.x + obstacle.object.hitbox.x < 0 then
            table.remove(self.obstacles, i)
        end
    end

    self.obstacle_distance = 700

    for _, obstacle in ipairs(self.obstacles) do
        obstacle.object.sprite:update(dt)
    end
end

function Obstacles:generateObstacle(next_obstacle)
    -- Get a random obstacle from the list
    local obstacle = {}

    if next_obstacle == 'cactus' then
        local max = 0

        -- Change game difficulty based on the speed
        if game.speed > 1200 then
            max = 6
        elseif game.speed > 700 then
            max = 4
        else
            max = 2
        end

        obstacle.object = self.cactus[math.random(1, max)]
    elseif next_obstacle == 'bird' then
        obstacle.object = self.bird[math.random(1, #self.bird)]
    end

    obstacle.pos = Vector(love.graphics.getWidth(), love.graphics.getHeight() - obstacle.object.hitbox.y)

    if next_obstacle == 'bird' then
        if (math.random(1, 2) == 1) then
            obstacle.pos.y = obstacle.pos.y - obstacle.object.hitbox.y
        end
    end

    table.insert(self.obstacles, obstacle)
end

function Obstacles:checkCollision(player)
    for _, obstacle in ipairs(self.obstacles) do
        if player.pos.x + player.hitbox.x > obstacle.pos.x and 
        player.pos.x < obstacle.pos.x + obstacle.object.hitbox.x and 
        player.pos.y + player.hitbox.y > obstacle.pos.y and 
        player.pos.y < obstacle.pos.y + obstacle.object.hitbox.y then
            return true
        end
    end

    return false
end

function Obstacles:draw()
    for _, obstacle in ipairs(self.obstacles) do
        obstacle.object.sprite:draw(obstacle.pos.x, obstacle.pos.y)
    end

    if debug then
        love.graphics.setColor(1, 0, 0)
        for _, obstacle in ipairs(self.obstacles) do
            love.graphics.rectangle('line', obstacle.pos.x, obstacle.pos.y, obstacle.object.hitbox.x,
            obstacle.object.hitbox.y)
        end
        love.graphics.setColor(1, 1, 1)
    end
end

return Obstacles
