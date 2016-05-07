local FX  = require "fx"

--Function for goal_up button
function goal_up()
    local this = goal_up
    local x = this.x
    local y = this.y
    local w = this.w
    local h = this.h
    local exp_color = COLOR(65,168,17)   --Color of particle explosion

    --Particles
    FX.particle_explosion(x+w/2, y+h/2, exp_color, duration, max_part, speed, decaying) 

    --Shrink effect
    if not GOAL_UP_FLAG then
        FX.pulse(goal_up, 0.85, 0.85)
        GOAL_UP_FLAG = true
        Game_Timer.after(.2, function() GOAL_UP_FLAG = false end)
    end

    GOAL = GOAL + 1
end

--Return function
return goal_up
