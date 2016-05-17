local RGB = require "rgb"
local FX  = require "fx"

--Function that changes player 'n' color to another available color
function changeColor(n)
    local color_id, rgb_b, rgb_h, color_t
    local pl, p, d, handle

    d = .4

    p = P_T[n]

    --Get new color
    color_id = RGB.randomBaseColor()
    rgb_b = RGB.randomColor(color_id)
    rgb_h = RGB.randomDarkColor(rgb_b)

    --Free color id
    C_MT[p.color_id] = 0

    --Change player color
    p.b_color = rgb_b
    p.h_color = rgb_h
    p.color_id = color_id

    --Counting the perceptive luminance - human eye favors green color... 
    pl = 1 - ( 0.299 * p.b_color.r + 0.587 * p.b_color.g + 0.114 * p.b_color.b)/255;

    if pl < 0.5 then
        color_t = COLOR(0, 0, 0, 255)       --bright colors - using black font
    else
        color_t = COLOR(255, 255, 255, 255) --dark colors - using white font
    end

    --Fix in case of several transitions
    handle = H_T["h"..p.number.."cg1"]
    if handle then
        Game_Timer.cancel(handle)
        H_T["h"..p.number.."cg1"] = nil
    end
    handle = H_T["h"..p.number.."cg2"]
    if handle then
        Game_Timer.cancel(handle)
        H_T["h"..p.number.."cg2"] = nil
    end
    handle = H_T["h"..p.number.."cg3"]
    if handle then
        Game_Timer.cancel(handle)
        H_T["h"..p.number.."cg3"] = nil
    end

    --Change player button colors
    H_T["h"..p.number.."cg1"] = FX.smoothColor(PB_T["P"..n.."pb"].b_color, rgb_b, d, "linear")
    H_T["h"..p.number.."cg2"] = FX.smoothColor(PB_T["P"..n.."pb"].t_color, color_t, d, "linear")
    H_T["h"..p.number.."cg3"] = FX.smoothColor(B_T["P"..n.."but"].b_color, rgb_h, d, "linear")

    --Fix in case of several transitions
    handle = H_T["handle"..p.number.."colorchangeset"] 
    if handle then
        Game_Timer.cancel(handle)
        H_T["handle"..p.number.."colorchangeset"] = nil
    end
    
    --Set colors
    handle = Game_Timer.after(d,
            function()
                PB_T["P"..n.."pb"].b_color = rgb_b   --Player button body
                PB_T["P"..n.."pb"].t_color = color_t --Player button text
                B_T["P"..n.."but"].b_color = rgb_h   --Color button
            end
        )
    H_T["handle"..p.number.."colorchangeset"] = handle

end

--Return function
return changeColor