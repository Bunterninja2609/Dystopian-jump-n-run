-- Love2D Code Example with Physics, Player Rectangle, and Ground

local world, player, ground

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    sti = require 'sti'
    cam = require 'camera'
    gameMap = sti('map/map.lua')
    love.window.setTitle("Dystopian game")
    love.window.setMode(800, 600, {resizable=true, vsync=false, minwidth=400, minheight=300})

    -- Initialize the physics world
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81 * 64, true)

    -- Create a rectangle for the player
    player = {}
    player.body = love.physics.newBody(world, 200, 300, "dynamic")
    player.shape = love.physics.newRectangleShape(50, 50)
    player.fixture = love.physics.newFixture(player.body, player.shape)

    -- Create the ground
    ground = {}
    ground.body = love.physics.newBody(world, 400, 550, "static")
    ground.shape = love.physics.newRectangleShape(800, 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape)
end

function love.update(dt)
    local contacts = player.body:getContacts()
    local vx, vy = player.body:getLinearVelocity()

    -- Move the player left
    if love.keyboard.isDown('a') then
        player.body:setX(player.body:getX() - 2)
    end

    -- Jump if the player is on the ground
    if love.keyboard.isDown('space') and #contacts > 0 then
        vy = vy - 10
    end

    -- Move the player right
    if love.keyboard.isDown('d') then
        player.body:setX(player.body:getX() + 2)
    end

    player.body:setLinearVelocity(vx, vy)
    
    -- Update the physics world
    world:update(dt)
end

function love.draw()
    scale = 1.1
    love.graphics.push()
    
    love.graphics.scale(scale)
    love.graphics.translate((-player.body:getX() + (love.graphics.getWidth()/2))/ scale, 0)
    -- Set the color to red for the player
    love.graphics.setColor(1, 0, 0)
    -- Draw the player rectangle
    love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))

    -- Set the color to blue for the ground
    love.graphics.setColor(0, 0, 1)
    -- Draw the ground rectangle
    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
    love.graphics.setColor(1, 1, 1)
    gameMap:drawLayer(gameMap.layers["Tile Layer 1"])

    love.graphics.pop()
end