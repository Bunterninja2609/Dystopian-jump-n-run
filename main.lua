function love.load()
    World = love.physics.newWorld(0, 10, false)
    player = {}
    player.body = love.physics.newBody(World, 0, 0)
    player.hitbox = love.physics.newShape(16, 32)
    player.fixture = love.physics.newFixture(player.body, player.hitbox)
    player.x = player.body:getX()
    player.y = player.body:getY()
end
function movePlayer(dt)
    local contacts = player.body:getContactList()
    local vx, vy = player.Body:getLinearVelocity()
    if contacts# > 0 and love.keyboard.isDown("Space") then
        vy = 20
    end
    if love.keyboard.isDown("d") then 
        vx = vx + dt
    end
    if love.keyboard.isDown("a") then
        vx = vx - dt
    end
    if vx < 30 then 
        vx = 30
    end
    player.Body:setLinearVelocity(vx, vy)
end
function love.update(dt)
    movePlayer()
    World:update(dt)
end

function love.draw()
    love.graphics.translate(- player.x - love.graphics.getWidth()/2, 0)
    love.graphics.rectangle("line", player.x - 8, player.y - 16, 16, 32)
end