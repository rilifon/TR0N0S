
--Function that enables player 'n' to change his name
function changeName(n)
    local b, x, y, w, h, sx, sy, text, font, color, img
    
    --Creates a textbox displaying player new name
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
    
    HUD_T["typingbox"] = b

    --Enables name change for player 'n'
    PLAYER_TYPING = n
    PLAYER_IS_TYPING = true

    -- Enable key repeat so keys can be hold for multiple keypressed events
    love.keyboard.setKeyRepeat(true)

end


return changeName