local FX  = require "fx"
local RGB = require "rgb"
local UD  = require "utildraw"

local duration = .5  --Duration of particles
local max_part = 45  --Max number of particles
local speed    = 200 --Speed of particles
local decaying = .99 --Decaying speed of particles

--Function for n_player_up button
function n_player_up()
    local this = n_player_up
    local x = this.x
    local y = this.y
    local w = this.w
    local h = this.h
    local pbh = PB_T["P"..N_PLAYERS.."pb"].h + 5 --Height of players button
    local x_nil = 0
    local exp_color --Color of particle explosion
    local bot

    if N_PLAYERS < MAX_PLAYERS then
       
        --Increases players
        N_PLAYERS = N_PLAYERS + 1
        I_T["n_players_value"].text = N_PLAYERS

        --Particles
        exp_color = COLOR(65,168,17)
        FX.particle_explosion(x+w/2, y+h/2 + 4*pbh/5, exp_color, duration, max_part, speed, decaying)--Button explosion
        exp_color = COLOR(205,144,212)
        FX.particle_explosion(2*love.graphics.getWidth()/8 + 60, 200, exp_color, duration, 20, speed, .98) --Value

        --Shrink effect
        if not N_PLAYER_UP_FLAG then
            FX.pulse(n_player_up, 0.95, 0.95, .4)
            N_PLAYER_UP_FLAG = true
            Game_Timer.after(.2, function() N_PLAYER_UP_FLAG = false end)
        end
        
        --Insert new CPU player
        color_id = RGB.randomBaseColor()
        rgb_b = RGB.randomColor(color_id)
        rgb_h = RGB.randomDarkColor(rgb_b)
        p = PLAYER(N_PLAYERS, false, nil, nil, nil, nil, rgb_b, rgb_h, true, 1, nil)
        p.color_id = color_id
        table.insert(P_T, p)

        --Adjust positions of buttons
        FX.smoothMove(n_player_up, n_player_up.x, n_player_up.y + pbh, .5, 'out-back')
        FX.smoothMove(n_player_down, n_player_down.x, n_player_down.y + pbh, .5, 'out-back')
        
        bot = I_T["bot_pb_i"]

        FX.smoothMove(bot, bot.x, bot.y + pbh, .4, 'out-back')

        --Creates a player button on setup screen
        UD.createPlayerButton(p)

    end
end

--Return function
return n_player_up