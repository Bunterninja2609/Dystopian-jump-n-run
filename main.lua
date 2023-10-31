-- Love2D Code Example with Physics and a Player Rectangle

local world, player

function love.load()
    love.window.setTitle("Dystopian game")
    love.window.setMode(800, 600, {resizable=true, vsync=false, minwidth=400, minheight=300})

    -- Initialize the physics world
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81 * 64, true)

    -- Create a rectangle
    player = {}
    player.body = love.physics.newBody(world, 200, 300, "dynamic")
    player.shape = love.physics.newRectangleShape(50, 50)
    player.fixture = love.physics.newFixture(player.body, player.shape)
end

function love.update(dt)
    local contacs = player.body:getContactList()
    local vx, vy = player.body:getLinearVelocity()
    -- Move the player left
    if love.keyboard.isDown('a') then
        player.body:setX(player.body:getX() - 2)
    end
    if love.keyboard.isDown('space') and #contacs > 0 then
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
    love.graphics.push()
        love.graphics.translate(-player.body:getX() + love.graphics:getWidth()/2, 0)
        -- Set the color to red
        love.graphics.setColor(1, 0, 0)

        -- Draw the player rectangle
        love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))
    love.graphics.pop()
end

