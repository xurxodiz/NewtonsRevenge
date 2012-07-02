-- bodies, affected by gravity and blocks

function body_new()
   
    local body = Collider:addRectangle(0, 0, 64, 64)
    body.type = "body"
    
    body.maxspd = 240
    body.yspd = 0
    body.xspd = 0
    body.xacc = 10
    body.yacc = 10
    body.xfrc = 3
    body.xdec = 7
    body.x = 64
    body.y = 64
    
    body.xoff = 32
    body.yoff = 32
    
    body.xflip = 1
    body.yflip = 1
    
    body.go_left = false
    body.go_right = false
    body.go_down = true
    body.go_up = false
    
    return body
    
end

function body_set_frames(body, sprites)
    
    body.sprites = sprites
    
    body.sprites.timer = Timer.new()
    
    body.sprites.timer:addPeriodic(0.1, function()
        body.sprites.current:next() 
    end)
    
    body.sprites.current = body.sprites.x
end

function body_adjust(body, dt)
    body_adjust_xspd(body) 
    body_adjust_yspd(body) 
    body_adjust_step(body, dt)
    body_adjust_pos(body)
    if body.sprites then
        body.sprites.timer:update(dt)
    end
end

function body_adjust_step(body,dt)
    body.x = body.x + body.xspd * dt
    body.y = body.y + body.yspd * dt
end

function body_adjust_xspd(body)
    
    if body.go_left then
        if body.xspd > 0 then
            body.xspd = body.xspd - body.xdec
            if body.xspd < 0 then body.xspd = -body.xdec end
        else
            body.xspd = body.xspd - body.xacc
            if body.xspd < -body.maxspd then body.xspd = -body.maxspd end
        end
        
    elseif body.go_right then
        if body.xspd < 0 then
            body.xspd = body.xspd + body.xdec
            if body.xspd > 0 then body.xspd = body.xdec end
        else
            body.xspd = body.xspd + body.xacc
            if body.xspd > body.maxspd then body.xspd = body.maxspd end
        end
        
    else
        if body.xspd > 1 then
            factor = 1
        elseif body.xspd < 1 then
            factor = -1
        else
            factor = 0
        end
        body.xspd = body.xspd - math.min(math.abs(body.xspd),body.xfrc) * factor
    end
    
    if body.xspd < 0 then body_move_left(body)
    elseif body.xspd > 0 then body_move_right(body)
    else body_move_stop(body) end

end

function body_adjust_yspd(body)
    if body.go_up then
        body.yspd = body.yspd - body.yacc
    elseif body.go_down then
        body.yspd = body.yspd + body.yacc
    end
    
    if body.yspd < 0 then body_move_up(body)
    elseif body.yspd > 0 then body_move_down(body)
    end
end

function body_adjust_pos(body)
    body:moveTo(body.x, body.y)
end

function body_die(body)
    body_move_dead(body)
    body.dead = true
    body.xspd = body.xspd/2
    body.yspd = body.yspd/2
    body.go_down = true
    body.go_up = false
    body.go_left = false
    body.go_right = false
end

function body_live(body)
    body.dead = false
    body.go_down = true
    body.go_up = false
    body.go_left = false
    body.go_right = false
    body_move_stop(body)
end

function body_move_left(body)
    if not body.dead then
        body.xflip = -1
        if body.sprites and body.sprites.x then
            body.sprites.current = body.sprites.x
        end
    end
end

function body_move_right(body)
    if not body.dead then
        body.xflip = 1
        if body.sprites and body.sprites.x then
            body.sprites.current = body.sprites.x
        end
    end
end

function body_move_up(body)
    if not body.dead then body.yflip = -1 end
end

function body_move_down(body)
    if not body.dead then body.yflip = 1 end
end

function body_move_stop(body)
    if not body.dead then
        if body.sprites then
            if body.sprites.stop then
                body.sprites.current = body.sprites.stop
            else
                body.sprites.current = body.sprites.x
            end
        end
    end
end

function body_move_dead(body)
    if not body.dead then
        if body.sprites and body.sprites.dead then
            body.sprites.current = body.sprites.dead
        end
    end
end

function body_hit_x(body, mtv_x)
    body.x = body.x + mtv_x
    body.xspd = 0
    body:moveTo(body.x, body.y)
end

function body_hit_y(body, mtv_y)
    body.y = body.y + mtv_y
    body.yspd = 0
    body:moveTo(body.x, body.y)
end

function body_phase(body, mtv_x, mtv_y)
    if body.type == "apple" and body.doomed then
        return apple_agony(body,0)
    end
    body.x = map_pixwidth() - body.x
    body.y = body.y - mtv_y -10
    body_adjust_pos(body)
end

function body_draw(body) 
    love.graphics.draw(body.image, body.x, body.y, 0,
                        body.xflip, body.yflip,
                        body.xoff, body.yoff)
end

function body_draw_sprites(body)
    if body.sprites then
        love.graphics.drawq(body.image, body.sprites.current:get(),
                        body.x, body.y, 0, body.xflip, body.yflip,
                        body.xoff, body.yoff)
    end
end