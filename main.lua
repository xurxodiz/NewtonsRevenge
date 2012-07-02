Timer      = require 'hump.timer'
Ringbuffer = require 'hump.ringbuffer'
HC         = require 'hardoncollider'
ATL        = require 'advtiledloader'

require '/src/hero'
require '/src/map'
require '/src/collisions'
require '/src/apples'
require '/src/body'
require '/src/score'
require '/src/item'

local msg_timer = Timer.new()
local msg = {}

function love.load()
    
    Collider = HC()
    Collider:setCallbacks(on_collision, collision_stop)
    allSolidTiles = map_find_solid_tiles()
    map_create_sides()
    
    apples_set()
    hero_new()
    score_new()
    items_set()
    
    snd_main     = love.audio.newSource("/res/main.mp3")
    snd_spybreak = love.audio.newSource("/res/spybreak.mp3")
    
    snd_expl     = love.audio.newSource("/res/explosion.wav","static")
    snd_death    = love.audio.newSource("/res/pain.mp3"     ,"static")
    snd_sword    = love.audio.newSource("/res/sword.wav"    ,"static")	
    snd_up1      = love.audio.newSource("/res/1Up.mp3"      ,"static")
    snd_prisoner = love.audio.newSource("/res/prisoner.mp3" ,"static")

    play_main()
end

function play_main()
    love.audio.stop()
    love.audio.play(snd_main)
end

function play_spybreak()
    love.audio.stop()
    love.audio.play(snd_spybreak)
end    

function play_explosion()
    love.audio.play(snd_expl)
end

function play_death()
    love.audio.play(snd_death)
end

function play_sword()
    love.audio.play(snd_sword)
end

function play_up1()
    love.audio.play(snd_up1)
end

function play_prisoner()
    love.audio.play(snd_prisoner)
end

function love.update(dt)
    if not gamestop then
        hero_update(dt)
        apples_update(dt)
        Collider:update(dt)
        score_update(dt)
        items_update(dt)
    end
    msg_timer:update(dt)
end

function love.keypressed(key)
    if key == "p" then
        if gamestop then
            game_go()
        else
            game_pause()
        end
    
    elseif key == "escape" then
        love.event.quit()
    else
        hero_notify_key_down(key)
    end
end

function love.keyreleased(key)
    hero_notify_key_up(key)
end

function love.draw()
    map_draw()
    hero_draw()
    apples_draw()
    score_draw()
    items_draw()
    if msg.display then
        display()
    end
end

function game_go()
    gamestop = false
    love.audio.resume()
    msg_empty()
end

function game_over()
    gamestop = true
    love.audio.stop()
    msg_loser()
end

function game_pause()
    gamestop = true
    love.audio.pause()
    msg_pause()
end

function msg_empty()
    msg = { display = nil,
            sx = 1,
            sy = 1
    }
end

function msg_loser()
    msg = { display = "LOSER",
            sx = 1,
            sy = 1,
            size = 200
    }
end

function msg_pause()
    msg = { display = "PAUSE",
            sx = 1,
            sy = 1,
            size = 100
    }
end

function msg_freebie()
    msg = { display = "THAT WAS\nA FREEBIE",
            sx = 0.5,
            sy = 2,
            size = 150
    }
end

function msg_better()
    msg = { display = "DO BETTER\nTHIS TIME",
            sx = 0.5,
            sy = 2,
            size = 150
    }
end

function msg_troll()
    msg = { display = "LOL",
            sx = 1,
            sy = 1,
            size = 400
    }
end 

function display()
    if not msg.display then return end
    
    local font = love.graphics.newFont(msg.size)
    local w = font:getWidth(msg.display)
    local h = font:getHeight(msg.display)
    
    local x = (map_pixwidth() -w*msg.sx)/2
    local y = (map_pixheight()-h*msg.sy)/2
    
    love.graphics.setFont(font)
    love.graphics.setColor(255,   0,   0, 255)
    love.graphics.print(msg.display, x, y)
    love.graphics.setColor(255, 255, 255, 255)
end

function threefortwo()
    game_pause()
    msg_freebie()
    
    msg_timer:add(1.75, function()
        msg_better()
        hero_plus_life()
    end)
    
    msg_timer:add(3.5, function()
        msg_empty()
        game_go()
    end)
end
