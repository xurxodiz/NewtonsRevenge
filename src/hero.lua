-- hero related methods

local hero_respawn_timer = Timer.new()
local three_for_two = false

function hero_new()
    
    hero = body_new()
    hero.type = "hero"
    
    hero.lives = 2
    hero.invincible = false
    
    hero_sprites_std()

end

function hero_update(dt)
    body_adjust(hero, dt)  
    hero_respawn_timer:update(dt)  
end

function hero_notify_key_down(key)
    if not hero.dead then
        if key == "left" then
            hero.go_left = true
        elseif key == "right" then
            hero.go_right = true
        elseif key == "up" then
            hero.go_up = true
            hero.go_down = false
        elseif key == "down" then
            hero.go_down = true
            hero.go_up = false
        end
    end
end

function hero_notify_key_up(key)
    if not hero.dead then
        if key == "left" then
            hero.go_left = false
        elseif key == "right" then
            hero.go_right = false
        end
    end
end

function hero_saiyan()
    if not hero.saiyan then
        play_sword()
        hero.saiyan = true
        hero.invincible = true
        hero_sprites_saiyan()
    end
end

function hero_desaiyan()
    hero.saiyan = false
    hero.invincible = false
    hero_sprites_std()
end

function hero_die()
    
    hero_minus_life()
    
    hero_sprites_blink()
    body_move_down(hero)
    body_die(hero)

    if not three_for_two then
        threefortwo()
        three_for_two = true
    end

    if hero.lives < 0 then
        game_over()
    else
        hero_respawn_timer:add(3, function()
            hero.invincible = true
            body_live(hero)
        end)
        hero_respawn_timer:add(6, function()
            hero.invincible = false
            hero_sprites_std()
        end)
    end
end

function hero_plus_life()
    hero.lives = hero.lives +1
    play_up1()
end

function hero_minus_life()
    hero.lives = hero.lives -1
    play_death()
end

function hero_sprites_saiyan()
    hero.image = love.graphics.newImage "/res/ninja_yellow.png"

    local Quad = love.graphics.newQuad

    local qx, qy =  64, 64
    local sx, sy = 384, 64

    local sprites = {
        x = Ringbuffer(
            Quad(  0,   0, 64, 64, sx, sy),
            Quad( 64,   0, 64, 64, sx, sy),
            Quad(128,   0, 64, 64, sx, sy),
            Quad(192,   0, 64, 64, sx, sy),
            Quad(256,   0, 64, 64, sx, sy),
            Quad(320,   0, 64, 64, sx, sy)
        );
    }

    body_set_frames(hero, sprites)
end

function hero_sprites_std()
    
    hero.image = love.graphics.newImage "/res/ninja_red.png"
    
    local Quad = love.graphics.newQuad
    
    local qx, qy =  64,  64
    local sx, sy = 640, 64

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
            Quad(384, 0, 64, 64, sx, sy)
        );
        dead = Ringbuffer(
            Quad(576, 0, 64, 64, sx, sy)
        );
    }
    
    body_set_frames(hero, sprites)
end

function hero_sprites_blink()

    hero.image = love.graphics.newImage "/res/ninja_red.png"

    local Quad = love.graphics.newQuad

    local qx, qy =  64,  64
    local sx, sy = 640, 64

    local sprites = {
        x = Ringbuffer(
            Quad(  0, 0, 64, 64, sx, sy),
            Quad(512, 0, 64, 64, sx, sy),
            Quad( 64, 0, 64, 64, sx, sy),
            Quad(512, 0, 64, 64, sx, sy),
            Quad(128, 0, 64, 64, sx, sy),
            Quad(512, 0, 64, 64, sx, sy),
            Quad(192, 0, 64, 64, sx, sy),
            Quad(512, 0, 64, 64, sx, sy),
            Quad(256, 0, 64, 64, sx, sy),
            Quad(320, 0, 64, 64, sx, sy),
            Quad(512, 0, 64, 64, sx, sy)
        );
        stop = Ringbuffer(
            Quad(384, 0, 64, 64, sx, sy),
            Quad(512, 0, 64, 64, sx, sy)
        );
        dead = Ringbuffer(
            Quad(576, 0, 64, 64, sx, sy),
            Quad(512, 0, 64, 64, sx, sy)
        );
    }

    body_set_frames(hero, sprites)
end

function hero_draw() 
    body_draw_sprites(hero)
end