local FX  = require "fx"
local UD  = require "utildraw"

--Function for n_player_down button
function n_player_down()
    local this = n_player_down
    local x = this.x
    local y = this.y
    local w = this.w
    local h = this.h
    local pbh = PB_T["P"..N_PLAYERS.."pb"].h + 5 --Height of players button
    local exp_color = COLOR(217,9,18)   --Color of particle explosion)
    local bot 

    if N_PLAYERS > 1 then
        
        --Particles
        FX.particle_explosion(x+w/2, y+h/2 - 3*pbh/5, exp_color, duration, max_part, speed, decaying)

        --Shrink effect
        if not N_PLAYER_DOWN_FLAG then
            FX.pulse(n_player_down, 0.95, 0.95,.4)
            N_PLAYER_DOWN_FLAG = true
            Game_Timer.after(.2, function() N_PLAYER_DOWN_FLAG = false end)
        end

        p = P_T[N_PLAYERS]
        if p.control == "WASD" then WASD_PLAYER = 0
        elseif p.control == "ARROWS" then ARROWS_PLAYER = 0 end
        
        --"Free" player color
        C_MT[p.color_id] = 0

        --Removes last player
        table.remove(P_T, N_PLAYERS)
        
        --Adjust positions of buttons
        FX.smoothMove(n_player_up, n_player_up.x, n_player_up.y - pbh, .3, 'in-out-sine')
        FX.smoothMove(n_player_down, n_player_down.x, n_player_down.y - pbh, .3, 'in-out-sine')
        
        bot = I_T["bot_pb_i"]

        FX.smoothMove(bot, bot.x, bot.y - pbh, .3, 'in-out-sine')

        --Decreases players
        N_PLAYERS = N_PLAYERS - 1

        UD.removePlayerButton(p)

    end
end

--Return function
return n_player_down
