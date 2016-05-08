local FX = require "fx"

--MODULE FOR USEFUL AND HELPFUL STUFF FOR DRAWING--

local ud = {}

--Buttons functions

local player_button_func = require "buttons.player_button"

---------------------------------
--PLAYER INDICATOR DRAW FUNCTIONS
---------------------------------

--Draw players indicator
function ud.setupPlayerIndicator()
    local label, txt, x, y, color, sx, sy
    local font = font_reg_s

    sx = 1.5
    sy = 1.5
    
    for i, p in ipairs(P_T) do
        --Creates player indicator text

        --Choose color
        if p.control == "WASD" or p.control == "ARROWS" then
            color = COLOR(250, 255, 97)
        else
            color = COLOR(97, 215, 255)
        end

        label = "player"..p.number.."txt"
        x = (p.x-1)*TILESIZE + BORDER
        y = (p.y-5)*TILESIZE + BORDER
        txt = TXT(x, y, "P" .. p.number, font, color)
        TXT_T[label] = txt

        --Creates players control/CPU text
        if  p.control == "WASD" then
            label = "WASD"
            x = (p.x-2)*TILESIZE + 1 + BORDER
            y = (p.y-3)*TILESIZE + BORDER
            txt = TXT(x, y, "WASD", font, color)
        elseif p.control == "ARROWS" then
            label = "ARROWS"
            x = (p.x-2)*TILESIZE - 7 + BORDER
            y = (p.y-3)*TILESIZE + BORDER
            txt = TXT(x, y, "ARROWS", font, color)
        else
            label = "CPU"..i
            x = (p.x-1)*TILESIZE - 4 + BORDER
            y = (p.y-3)*TILESIZE + BORDER
            txt = TXT(x, y, "CPU", font, color)
        end
        TXT_T[label] = txt
        
        --Pulse effect
        if p.control == "WASD" or p.control == "ARROWS" then
            FX.pulse(TXT_T[label], sx, sy, MAX_COUNTDOWN)
            label = "player"..p.number.."txt"
            FX.pulse(TXT_T[label], sx, sy, MAX_COUNTDOWN)
        end

    end

end

--Remove all player indicator text
function ud.removePlayerIndicator()

    for i, p in ipairs(P_T) do
        TXT_T["player"..p.number.."txt"] = nil
        if  p.control == "WASD" then
            TXT_T["WASD"] = nil
        elseif p.control == "ARROWS" then
            TXT_T["ARROWS"] = nil
        else
            TXT_T["CPU"..i] = nil
        end
    end

end

-----------------------------------
--PLAYER BUTTON/INDICATOR FUNCTIONS
-----------------------------------

function ud.createPlayerButton(p)
    local font = font_but_mml
    local color_b, color_t, cputext, controltext, pl
    local pb, box, x, y, w, h, w_cb, h_cb, tween

    w_cb = 40 --Width of head color box
    h_cb = 40 --Height of head color box

    --Fix case where a timer is rolling to remove the button and active
    -- the button and active transitions
    if H_T["h"..p.number] then

        --Remove timer related to removing player button
        Game_Timer.cancel(H_T["h"..p.number])
        H_T["h"..p.number] = nil

        --Remove timer related to changing playeer button alpha
        if PB_T["P"..p.number.."pb"] then
            Game_Timer.cancel(PB_T["P"..p.number.."pb"].h)
        end

        --Remove timer related to changing player head box alpha
        if TB_T["P"..p.number.."tb"] then
            Game_Timer.cancel(TB_T["P"..p.number.."tb"].h)
        end
        
    end

     if p.cpu then
            cputext = "CPU"
            controltext = "Level " .. p.level
        else
            cputext = "HUMAN"
            controltext = p.control
    end

    --Counting the perceptive luminance - human eye favors green color... 
    pl = 1 - ( 0.299 * p.b_color.r + 0.587 * p.b_color.g + 0.114 * p.b_color.b)/255;

    if pl < 0.5 then
        color_t = COLOR(0, 0, 0, 0)       --bright colors - using black font
    else
        color_t = COLOR(255, 255, 255, 0) --dark colors - using white font
    end

    color_b = COLOR(p.b_color.r, p.b_color.g, p.b_color.b, 0)

    --Creates player button
    w = 500
    h = 40
    x = (love.graphics.getWidth() - w - w_cb)/2
    y = 240 + 45*p.number
    pb = But(x, y, w, h,
                    "PLAYER " .. p.number .. " " .. cputext .. " (" .. controltext .. ")",
                    font, color_b, color_t, player_button_func)
    PB_T["P"..p.number.."pb"] =  pb

    --Creates players head color box
    x = x + w
    box = BOX(x, y, w_cb, h_cb, p.h_color)
    BOX_T["P"..p.number.."box"] = box

    --Transitions
    pb.b_color.a = 0
    pb.t_color.a = 0
    box.color.a = 0
    tween = 'linear'
    FX.smoothAlpha(pb.b_color, 255, .4, tween)
    FX.smoothAlpha(pb.t_color, 255, .6, tween)
    FX.smoothAlpha(box.color, 255, .5, tween)

end

function ud.removePlayerButton(p)
    local duration = .2
    local pb, box

    pb  = PB_T["P"..p.number.."pb"]
    box = BOX_T["P"..p.number.."box"]
    
    --Fades out
    pb.b_color.a = 255
    pb.t_color.a = 255
    box.color.a  = 255
    FX.smoothAlpha(pb.b_color, 0, duration, 'linear')
    FX.smoothAlpha(pb.t_color, 0, duration, 'linear')
    FX.smoothAlpha(box.color, 0, duration, 'linear')
    
    H_T["h"..p.number] = Game_Timer.after(duration, 
        function()
            --Removes player button on setup screen
            PB_T["P"..p.number.."pb"] = nil
            BOX_T["P"..p.number.."box"] = nil
        end
    )
end


--Update players buttons on setup
function ud.updatePlayersB()

    for i, p in ipairs(P_T) do

        ud.createPlayerButton(p)

    end

end

-----------------
--DEBUG FUNCTIONS
-----------------

--Toggles DEBUG
function ud.toggleDebug()
    local font, color, DEBUG_TEXT

    if not DEBUG then 
        ud.createDebugText()
    else
        TXT_T["DEBUG"] = nil
        DEBUG = false
    end

end

--Toggles DEBUG_DRAW
function ud.toggleDebugDraw()
    local font, color, DEBUG_TEXT

    if not DEBUG_DRAW then 
        ud.createDebugDrawText()
    else
        TXT_T["DEBUG_DRAW"] = nil
        DEBUG_DRAW = false
    end

end

function ud.createDebugText()

    font = font_reg_s
    color = COLOR(255, 255, 255)
    DEBUG_TEXT = TXT(150, love.graphics.getHeight() - 2* TILESIZE, "DEBUG ON", font, color)
    TXT_T["DEBUG"] = DEBUG_TEXT
    DEBUG = true

end

function ud.createDebugDrawText()

    font = font_reg_s
    color = COLOR(255, 255, 255)
    DEBUG_TEXT = TXT(650, love.graphics.getHeight() - 2* TILESIZE, "DEBUG DRAW ON", font, color)
    TXT_T["DEBUG_DRAW"] = DEBUG_TEXT
    DEBUG_DRAW = true

end


--Return functions
return ud

