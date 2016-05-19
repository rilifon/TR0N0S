
--Function that enables player 'n' to change his name
function changeName(n)
    local tb, x, y, w, h, text, font, b_color, t_color
    
    --Creates a textbox displaying player new name
    x = love.graphics.getWidth()/2 - 30
    y = love.graphics.getHeight()/2 - 30
    w = 200
    h = 30
    text = ""
    font = font_but_m
    b_color = COLOR(255,255,255,255)
    t_color = COLOR(0,0,0,255)
    tb = TB(x, y, w, h, text, font, b_color, t_color)
    
    TB_T["typingbox"] = tb

    --Enables name change for player 'n'
    PLAYER_TYPING = n
    PLAYER_IS_TYPING = true

    -- Enable key repeat so keys can be hold for multiple keypressed events
    love.keyboard.setKeyRepeat(true)

end


return changeName