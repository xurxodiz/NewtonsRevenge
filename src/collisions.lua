-- collision related methods

function on_collision(dt, shape_a, shape_b, mtv_x, mtv_y)
    
    local actor
    local passive
    
    -- we want to take first the hero, if there's any
    -- and yeah, otherwise an apple
    
    if (shape_a.type == "hero") then
        actor = shape_a
        passive = shape_b
    elseif (shape_b.type == "hero") then
        actor = shape_b
        passive = shape_a
        mtv_x = -mtv_x
        mtv_y = -mtv_y
    elseif (shape_a.type == "apple") then
        actor = shape_a
        passive = shape_b
    elseif (shape_b.type == "apple") then
        actor = shape_b
        passive = shape_a
        mtv_x = -mtv_x
        mtv_y = -mtv_y
    elseif (shape_a.type == "item") then
        actor = shape_a
        passive = shape_b
    elseif (shape_b.type == "item") then
        actor = shape_b
        passive = shape_a
        mtv_x = -mtv_x
        mtv_y = -mtv_y
    else
        return
    end
    
    if (passive.type == "border") or
       (passive.type == "dump" and actor.type == "hero") then
        return body_phase(actor, mtv_x, mtv_y)
    end
    
    if (passive.type == "dump" and actor.type == "apple") then
        return apple_die(actor)
    end
    
    if actor.type == "hero" then
    
        if passive.type == "apple" then
            return impact_hero_apple(actor,passive)
        end
        
        if passive.type == "item" then
            return passive:action()
        end
    
    end

    if (passive.type == "tile") then
    
        if math.abs(mtv_x) > 0 then
            return body_hit_x(actor,mtv_x)
        end
    
        if math.abs(mtv_y) > 0 then
            return body_hit_y(actor,mtv_y)
        end
    
    end
    
end

-- this is called when two shapes stop colliding
function collision_stop(dt, shape_a, shape_b)
    -- ...
end

function impact_hero_apple(hero, apple)
    
    if hero.saiyan then
        return apple_explosion(apple)
        
    elseif apple.life then
        return apple_consume(apple)
    
    elseif hero.invincible or hero.dead then
        return
        
    else
        hero_die()
    end
    
end