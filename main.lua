-- Love2D Code Example with Physics, Player Rectangle, and Ground

local world, player, walls, gameMap
local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    sti = require 'sti'
    gameMap = sti('map/map.lua')
    love.window.setTitle("Dystopian game")
    love.window.setMode(800, 600, {resizable=true, vsync=false, minwidth=400, minheight=300})
    walls = {}
    mapPNG = love.graphics.newImage("map/map.png")
    -- Initialize the physics world
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81 * 64, true)

    background1 = love.graphics.newImage("background2.png")

    -- Create a rectangle for the player
    player = {}
    player.body = love.physics.newBody(world, 0, 80, "dynamic")
    player.body:setFixedRotation(true)
    player.shape = love.physics.newRectangleShape(16, 16)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setFriction(10)
    for i, obj in pairs(gameMap.layers["Object Layer 1"].objects) do
        local wall = {}
        wall.x = obj.x + obj.width / 2
        wall.y = obj.y + obj.height / 2
        wall.width = obj.width
        wall.height = obj.height
        wall.body = love.physics.newBody(world, wall.x, wall.y, "static")
        wall.shape = love.physics.newRectangleShape(wall.width, wall.height)
        wall.fixture = love.physics.newFixture(wall.body, wall.shape)
        table.insert(walls, wall)
    end
    for i, obj in pairs(gameMap.layers["Object Layer 1"].objects) do
        local wall = {}
        wall.x = obj.x + obj.width / 2 + 1600
        wall.y = obj.y + obj.height / 2
        wall.width = obj.width
        wall.height = obj.height
        wall.body = love.physics.newBody(world, wall.x, wall.y, "static")
        wall.shape = love.physics.newRectangleShape(wall.width, wall.height)
        wall.fixture = love.physics.newFixture(wall.body, wall.shape)
        table.insert(walls, wall)
    end
end

function love.update(dt)
    
    local contacts = player.body:getContacts()
    local vx, vy = player.body:getLinearVelocity()

    -- Move the player left
    if love.keyboard.isDown('a') then
        vx = -100
    end

    -- Jump if the player is on the ground
    if love.keyboard.isDown('space') and #contacts > 0 then
        vy = vy - 5
    end

    -- Move the player right
    if love.keyboard.isDown('d') then
        vx = 100
    end

    player.body:setLinearVelocity(vx, vy)
    
    -- Update the physics world
    world:update(dt)
    if player.body:getY() > 160 then
        love.event.quit(0)
    end
    if player.body:getX() > 1600 then
        player.body:setX(0)
    end
    if player.body:getX() < 0 then
        player.body:setX(1600)
    end

end

function love.draw()
    local scale = 2
    local playerX, playerY = player.body:getX(), player.body:getY()
    local translateX = screenWidth / 2 / scale - playerX
    local translateY =  screenHeight / 2 / scale + screenHeight/2/scale - 160
    love.graphics.setBackgroundColor(59/255, 55/255, 60/255)
    love.graphics.push()
    love.graphics.scale(scale)
    love.graphics.translate(translateX, translateY)
    for i = -10, 10 do
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.draw(background1, playerX/2 + i * background1:getWidth(),-screenHeight/4)
    end
    for i = -10, 10 do
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.draw(background1, playerX/5 + i * background1:getWidth(),-screenHeight/8)
        
    end
    for i = -10, 10 do
        love.graphics.setColor(1,1,1)
        
        love.graphics.draw(background1, playerX/10 + i * background1:getWidth(),-screenHeight/32)
    end
    for i = -10, 10 do
        love.graphics.setColor(1,1,1)
        
        love.graphics.draw(background1, playerX/20 + i * background1:getWidth(), 0)
    end
    
    love.graphics.setColor(1, 0, 0)
    -- Draw the player rectangle
    love.graphics.rectangle("fill", playerX - 8, playerY - 8, 16, 16)

    love.graphics.setColor(1, 1, 1)

    gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
    love.graphics.draw(mapPNG, -1600, 0)
    love.graphics.draw(mapPNG,  1600, 0)
    love.graphics.circle("fill",0,0,1)
    love.graphics.pop()
end
