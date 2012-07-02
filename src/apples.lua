-- apple related methods

local apples_count = 0
local apples_list = {}
local apples_factory_timer = Timer.new()
local apples_death_timer   = Timer.new()

local spawn_killable = false
local spawn_slow = false

function apples_set()
    apples_factory_timer:addPeriodic(2, function()
        apples_drop()
    end)
end

function apples_drop()
    
    local apple = body_new()
    
    apple.type = "apple"
    apple.doomed = false
    
    apple.x, apple.y = map_random_pos()
    body_adjust_pos(apple, 0)
    
    local rnd = math.random(0, 1)
    
    if (apples_count % 2 == 0) then
        apple.go_left = true
    else
        apple.go_right = true
    end

    apple_sprites_zombie(apple)
    
    apple.id = apples_count
    table.insert(apples_list, apple.id, apple)
    apples_count = apples_count+1
    
    apples_death_timer:add(10, function()
        apple.doomed = true
    end)
    
    if spawn_slow then
        apple_slow(apple)
    end
    
    local roll = math.random(0, 50)
    
    if roll == 0 then
        apple.life = true
        apple.image = love.graphics.newImage "/res/apple_life.png"
    else
        apple.life = false
    end
    
    return true
      
end

function apple_consume(apple)
    apple_agony(apple,0)
    hero_plus_life()
end

function apples_slow()
    spawn_slow = true
    for k,apple in pairs(apples_list) do
        apple_slow(apple)
    end
end

function apple_slow(apple)
    apple.maxspd = 60
    apple.xfrc = 0
    apple.xdec = 0
end

function apples_fast()
    spawn_slow = false
    for k,apple in pairs(apples_list) do
        apple.maxspd = 240
        apple.xfrc = 4
        apple.xdec = 5
    end
end    

function apples_update(dt)
    apples_factory_timer:update(dt)
    apples_death_timer:update(dt)
    for k,apple in pairs(apples_list) do
        body_adjust(apple,dt)
    end
end
    

function apple_die(apple)
    body_move_up(apple)
    body_die(apple)
    apple_agony(apple, 2)
end

function apple_agony(apple, delay)
    Collider:remove(apple)
    apples_death_timer:add(delay, function()
        apples_list[apple.id] = nil
    end)
end

function apples_explosion()
    for k,apple in pairs(apples_list) do
         apple_explosion(apple)
    end
end

function apple_explosion(apple)
    apple_sprites_explosion(apple)
    apple_agony(apple, 2)
    play_explosion()
    score_increase_apple()
end

function apple_sprites_zombie(apple)
    apple.image = love.graphics.newImage "/res/apple_zombie.png"
    
    local Quad = love.graphics.newQuad
    
    local qx, qy =  64, 64
    local sx, sy = 384, 64

    local sprites = {
        x = Ringbuffer(
            Quad(  0, 0, 64, 64, sx, sy),
            Quad( 64, 0, 64, 64, sx, sy),
            Quad(128, 0, 64, 64, sx, sy),
            Quad(192, 0, 64, 64, sx, sy),
            Quad(256, 0, 64, 64, sx, sy),
            Quad(320, 0, 64, 64, sx, sy)
        );
        stop = Ringbuffer(
            Quad(192, 0, 64, 64, sx, sy)
        );
    }

    body_set_frames(apple, sprites)
end

function apple_sprites_explosion(apple)
    apple.image = love.graphics.newImage "/res/apple_explosion.png"
    
    local Quad = love.graphics.newQuad
    
    local qx, qy =  64, 64
    local sx, sy = 320, 192

    local sprites = {
        x = Ringbuffer(
            Quad(  0,   0, 64, 64, sx, sy),
            Quad( 64,   0, 64, 64, sx, sy),
            Quad(128,   0, 64, 64, sx, sy),
            Quad(192,   0, 64, 64, sx, sy),
            Quad(256,   0, 64, 64, sx, sy),
            Quad(  0,   0, 64, 64, sx, sy),
            Quad( 64,  64, 64, 64, sx, sy),
            Quad(128,  64, 64, 64, sx, sy),
            Quad(192,  64, 64, 64, sx, sy),
            Quad(256,  64, 64, 64, sx, sy),
            Quad(  0,  64, 64, 64, sx, sy),
            Quad( 64, 128, 64, 64, sx, sy),
            Quad(128, 128, 64, 64, sx, sy),
            Quad(192, 128, 64, 64, sx, sy),
            Quad(256, 138, 64, 64, sx, sy)
        );
    }

    body_set_frames(apple, sprites)
end

function apples_draw()
    for k,apple in pairs(apples_list) do
        body_draw_sprites(apple)
    end
end