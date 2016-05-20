local FX = require "fx"

--Function that enables player 'n' to change his name
function changeName(n)
    local b, x, y, w, h, sx, sy, text, font, color, img
    
    --Creates an image for entry of players name
    img = IMG_TEXT_ENTRY
    w = img:getWidth()
    h = img:getHeight()
    x = love.graphics.getWidth()/2 - w/2
    y = love.graphics.getHeight()/2 - h/2
    sx = 1
    sy = 1
    text = ""
    font = font_but_m
    color = COLOR(0,0,0,255)
    b = But_Img(img, x, y, w, h, sx, sy, text, font, color)
    b.b_color = COLOR(255,255,255,0)
    HUD_T["typingbox"] = b

    --Creates filter
    F_T["textentry"] = FILTER(COLOR(125,45,217,0))

    --Creates explanatory text
    font = font_reg_m
    text = "Enter name for player " .. n
    y = love.graphics.getHeight()/2 - h/2 - font:getHeight(text) - 5
    color = COLOR(255, 255, 255, 0)
    transp = COLOR(0, 0, 0, 0)
    tb = TB(0, y, love.graphics.getWidth(), font:getHeight(text), text, font, transp,color)
    TB_T["textentry1"] = tb

    --Creates explanatory text 2
    font = font_reg_m
    text = "Press enter to confirm"
    y = love.graphics.getHeight()/2 + h/2 + 5
    color = COLOR(255, 255, 255, 0)
    transp = COLOR(0, 0, 0, 0)
    tb = TB(0, y, love.graphics.getWidth(), font:getHeight(text), text, font, transp,color)
    TB_T["textentry2"] = tb

    --FADE IN EFFECTS

    --Filter fade-in effect
    FX.smoothAlpha(F_T["textentry"].color, 200, .5, "linear")
    --Text-entry image fade-in effect
    FX.smoothAlpha(HUD_T["typingbox"].b_color, 255, .5, "linear")
    --Setup start text fade-out effect
    FX.smoothAlpha(TB_T["start"].t_color, 0, .5, "linear")
    --Text entry 1 fade-in effect
    FX.smoothAlpha(TB_T["textentry1"].t_color, 255, .5, "linear")
    --Text entry 2 fade-in effect
    FX.smoothAlpha(TB_T["textentry2"].t_color, 255, .5, "linear")

    --Enables name change for player 'n'
    PLAYER_TYPING = n
    PLAYER_IS_TYPING = true

    -- Enable key repeat so keys can be hold for multiple keypressed events
    love.keyboard.setKeyRepeat(true)

end


return changeName