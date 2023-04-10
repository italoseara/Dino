local Player = require 'assets/scripts/player'
local Background = require 'assets/scripts/background'
local Obstacles = require 'assets/scripts/obstacles'

debug = false

function love.load()
    love.window.setTitle('Dino Game')
    love.window.setMode(1000, 500, { resizable = false, vsync = true })
    love.graphics.setBackgroundColor(1, 1, 1)

    game = {}
    game.speed = 500
    game.max_speed = 1250
    game.state = 'idle'

    background = Background('assets/sprites/background/')
    obstacles = Obstacles('assets/sprites/obstacles/')
    player = Player(150, 500, 'assets/sprites/player/')
end

function love.update(dt)
    if game.state == 'running' then
        if game.speed < game.max_speed then
            game.speed = game.speed + 5 * dt
        end

        background:update(dt)
        obstacles:update(dt)

        if not debug and obstacles:checkCollision(player) then
            player:die()
        end
    end

    player:update(dt)
end

function love.draw()
    if debug then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print('Game speed: ' .. string.format('%.0f', game.speed), 10, 30)
        love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
        love.graphics.setColor(1, 1, 1)
    end

    if game.state ~= 'idle' then
        background:draw()
        obstacles:draw()
    end

    player:draw()
end
