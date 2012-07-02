-- methods dealing with items

local items_list = {}
local items_count = 0

local items_factory_timer = Timer.new()
local items_death_timer = Timer.new()
local items_action_timer = Timer.new()

local h_katana = nil
local h_slowpoke = nil
local h_troll = nil

function items_set()

    items_factory_timer:addPeriodic(5, function()
        items_drop(math.random(0, 4))
    end)
end

function items_drop(key)

    local item = body_new()

    item.type = "item" 
       
    if key == 0 then
        item.name = "slow"
        item.image = love.graphics.newImage "/res/slow.png"  
        item.action = item_slowpoke_on
        
    elseif key == 1 then
        item.name = "bomb"
        item.image = love.graphics.newImage "/res/bomb.gif" 
        item.action = item_bomb_on
        
    elseif key == 2 then
        item.name = "katana"
        item.image = love.graphics.newImage "/res/katanaSmall.png" 
        item.action = item_katana_on
        
    elseif key == 3 then
        item.name = "troll"
        item.image = love.graphics.newImage "/res/troll.png"
        item.action = item_troll_on

    elseif key == 4 then
        item.name = "prisoner"
        item.image = love.graphics.newImage "/res/prisoner.png"
        item.action = item_prisoner_on

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

        body_set_frames(item, sprites)
        item.action = item_prisoner_on
        
    end

    item.x, item.y = map_random_pos()
    body_adjust_pos(item, 0)
    
    local rnd = math.random(0, 1)
    
    item.id = items_count
    table.insert(items_list, item.id, item)
    items_count = items_count+1
    
    items_death_timer:add(7, function()
        item_remove(item)
    end)

    return true
      
end

function items_update(dt)
    items_factory_timer:update(dt)
    items_death_timer:update(dt)
    items_action_timer:update(dt)
    
    for k,item in pairs(items_list) do
        body_adjust(item,dt)
    end

end

function item_remove(item)
    Collider:remove(item)
    items_list[item.id] = nil
end

function items_draw()
    for k,item in pairs(items_list) do
        if item.name == "prisoner" then
            body_draw_sprites(item)
        else
            body_draw(item)
        end
    end
end

function item_bomb_on(self)
    apples_explosion()
    item_remove(self)
end

function item_katana_on(self)
    if h_katana then
        items_action_timer:cancel(h_katana)
        h_katana = nil
    end
    hero_saiyan()
    score_activate_katana()
    h_katana = items_action_timer:add(8, function()
        items_katana_off()
    end)
    if self then item_remove(self) end
end

function items_katana_off()
    score_deactivate_katana()
    hero_desaiyan()
    h_katana = nil
end

function item_slowpoke_on(self)
    if h_slowpoke then
        items_action_timer:cancel(h_slowpoke)
        h_slowpoke = nil
    end
    apples_slow()
    play_spybreak()
    score_activate_slow()
    h_slowpoke = items_action_timer:add(5, function()
        items_slowpoke_off()
    end)
    if self then item_remove(self) end
end

function items_slowpoke_off()
    apples_fast()
    play_main()
    score_deactivate_slow()
    h_slowpoke = nil
end

function item_prisoner_on(self)
    score_increase_prisoner()
    play_prisoner()
    if self then item_remove(self) end
end

function item_troll_on(self)
    local roll = math.random(0, 20)
    
    if roll < 10 then
        return
    elseif roll < 16 then
        hero_plus_life()
    elseif roll < 18 then
        item_slowpoke_on(nil)
    elseif roll == 17 then
        score_increase_prisoner()
    elseif roll == 19 then
        item_katana_on(nil)
    elseif roll == 20 then

        if h_troll then
            items_action_timer:cancel(h_troll)
            h_troll = nil
        end
        msg_troll()
        h_troll = items_action_timer:add(4, function()
            items_troll_off()
        end)
    end 

    item_remove(self)
end

function items_troll_off()
    msg_empty()
    h_troll = nil
end