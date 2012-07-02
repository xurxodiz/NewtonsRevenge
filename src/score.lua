-- functions dealing with the low screen timer


function score_new()
    score = {}
    score.time = 0
    score.fontt = love.graphics.newFont(45)
    score.fontx = love.graphics.newFont(24)
    
    score_deactivate_katana()
    score_deactivate_slow()
    
    score.lives    = love.graphics.newImage "/res/lives.gif"
    score.prisoner = love.graphics.newImage "/res/prisoner.gif"
    score.apple    = love.graphics.newImage "/res/apple.gif"
    
    score.apple_count = 0
    score.prisoner_count = 0
    

end

function score_update(dt)
    score.time = score.time + dt
end

function score_draw()
    
    local mins = score.time / 60
    local segs = score.time % 60
    
    local time      = string.format("%02d:%02d", mins, segs)
    local prisoners = string.format("x %02d", score.prisoner_count)
    local apples    = string.format("x %02d", score.apple_count)
    
    local lives
    if hero.lives >= 0 then
        lives = string.format("x %02d", hero.lives)
    else
        lives = "x --"
    end
    
    love.graphics.setColor(255, 255, 255, 255)
    
    love.graphics.setFont(score.fontt)
    love.graphics.print(time,          (map_pixwidth() / 2) -420, (map_pixheight() ) - 110)
    
    love.graphics.setFont(score.fontx)
    
    love.graphics.draw(score.slow,     (map_pixwidth() / 2) -225, (map_pixheight() ) - 125) 
    love.graphics.draw(score.katana,   (map_pixwidth() / 2) -110, (map_pixheight() ) - 120)     

    love.graphics.draw(score.apple,    (map_pixwidth() / 2) - 20, (map_pixheight() ) - 125) 
    love.graphics.print(apples,        (map_pixwidth() / 2) + 55, (map_pixheight() ) - 100)
    
    love.graphics.draw(score.prisoner, (map_pixwidth() / 2) +150, (map_pixheight() ) - 130)   
    love.graphics.print(prisoners,     (map_pixwidth() / 2) +215, (map_pixheight() ) - 100) 
    
    love.graphics.draw(score.lives,    (map_pixwidth() / 2) +290, (map_pixheight() ) - 125)  
    love.graphics.print(lives,         (map_pixwidth() / 2) +340, (map_pixheight() ) - 100) 

      
end

function score_activate_slow()
    score.slow = love.graphics.newImage "/res/slow.png" 
end

function score_deactivate_slow()
    score.slow = love.graphics.newImage "/res/slowShadow.png"
end

function score_activate_katana()
    score.katana = love.graphics.newImage "/res/katana.png" 
end

function score_deactivate_katana()
    score.katana = love.graphics.newImage "/res/katanaShadow.png"
end

function score_increase_prisoner()
    score.prisoner_count = score.prisoner_count+1
end

function score_decrease_prisoner()
    score.prisoner_count = score.prisoner_count-1
end

function score_increase_apple()
    score.apple_count = score.apple_count+1
end

function score_decrease_apple()
    score.apple_count = score.apple_count-1
end