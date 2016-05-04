local FX = require "fx"

--MODULE DRAWING PRIMITIVE OBJECTS AND STUFF--

local pr = {}

----------------------
--BASIC DRAW FUNCTIONS
----------------------

--Draws every drawable from tables
function pr.drawAll(mode)

    DrawBG()          --Draws the program background
    
    if mode == "inGame" then
        
        DrawMAP()     --Draws the map background

        DrawPlayers() --Draws all players on screen

    end

    DrawB()       --Draws all default buttons

    DrawBI()      --Draws all default buttons with images
    
    if mode ~= "inGame" then
        
        DrawBOX()     --Draws all default boxes

    end

    DrawPB()      --Draws all default player buttons

    DrawI()       --Draws all default images with text

    DrawPART()    --Draws all default particles

    DrawF()       --Draws all default filters

    DrawTXT()     --Draws all default texts

    DrawTB()      --Draws all default textboxes

end

--Draws the background
function DrawBG()

    --Draws the glow effect
    love.graphics.setShader(BG_Shader)
    SHADER = "BG"

    love.graphics.setColor(MAP_COLOR.r, MAP_COLOR.g, MAP_COLOR.b, MAP_COLOR.a)
    love.graphics.draw(IMG_BG, BG_X, -200)

    love.graphics.setShader()
    SHADER = nil

end

--Draws all default textboxes
function DrawTB()
    
    for i, v in pairs(TB_T) do
        drawTextBox(v)
    end

end

--Draws all default buttons
function DrawB()

    for i, v in pairs(B_T) do
        drawButton(v)
    end

end

--Draws all default buttons with images
function DrawBI()

    for i, v in pairs(BI_T) do
        drawButtonImg(v)
    end

end

--Draws all default images with text
function DrawI()

    for i, v in pairs(I_T) do
        drawImg(v)
    end

end


--Draws all default texts
function DrawTXT()

    for i, v in pairs(TXT_T) do
        drawText(v)
    end

end

--Draws all filters
function DrawF()

    for i, v in pairs(F_T) do
        drawFilter(v)
    end

end

--Draws all players buttons
function DrawPB()
   
    --Draws the glow effect
    love.graphics.setShader(Glow_Shader)
    SHADER = "Glow"
    for i, v in pairs(PB_T) do
        drawGlowButton(v)
    end
    love.graphics.setShader()
    SHADER = nil

    --Draws the player button
    for i, v in pairs(PB_T) do
        drawButton(v)
    end

end

--Draws all particles
function DrawPART()
   
    for i, v in pairs(PART_T) do
        drawParticle(v)
    end

end

--Draws all boxes with a glow effect below
function DrawBOX()
   
    for i, v in pairs(BOX_T) do
        drawBox(v)
    end

end

--Updates all background tiles
function DrawMAP()
    local x, y, w, h
    
    w = MAP_X*TILESIZE
    h = MAP_Y*TILESIZE
    x = BORDER
    y = BORDER

    love.graphics.setColor(MAP_COLOR.r, MAP_COLOR.g, MAP_COLOR.b, MAP_COLOR.a)
    love.graphics.draw(PIXEL, x, y, 0, w, h)

end

 --Draw players glow effect, body and heads
 --IS THE CAUSE OF LAG
function DrawPlayers()

    --Draws the glow effect
    love.graphics.setShader(Glow_Shader)
    SHADER = "Glow"
    for i, tile in pairs(GLOW_T) do
       drawGlowTile(tile)
    end
    love.graphics.setShader()
    SHADER = nil

    --Draws players bodies
    for i, box in pairs(BOX_T) do
        drawBox(box)
    end

    --Draws players heads
    for i, tile in pairs(HD_T) do
        drawTile(tile)
    end

end

-----------------------------
--PRIMITIVE DRAWING FUNCTIONS
-----------------------------

--Draws a given button
function drawButton(button)
    local fwidth, fheight, tx, ty, font

    --Draws button box
    love.graphics.setColor(button.b_color.r, button.b_color.g, button.b_color.b, button.b_color.a)
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
    
    fwidth  = button.font:getWidth( button.text) --Width of font
    fheight = button.font:getHeight(button.text) --Height of font
    tx = (button.w - fwidth)/2                   --Relative x position of font on textbox
    ty = (button.h - fheight)/2                  --Relative y position of font on textbox

    --Draws button text
    font = button.font
    love.graphics.setColor(button.t_color.r, button.t_color.g, button.t_color.b, button.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(button.text, button.x + tx , button.y + ty)

end

--Draws a glow for a given button
function drawGlowButton(button)
    local eps = EPS_2

    --Draws button glow
    love.graphics.setColor(button.b_color.r, button.b_color.g, button.b_color.b, button.b_color.a)
    love.graphics.draw(PIXEL, button.x-eps, button.y-eps, 0, button.w+2*eps, button.h+2*eps)
    

end

--Draws a given button with image
function drawButtonImg(but)
    local fwidth, fheight, tx, ty, font, fix

    fix = 5 --Fix font position on images

    --Draws image
    love.graphics.setColor(255,255,255)
    love.graphics.draw(but.img, but.x, but.y, 0, but.sx, but.sy)
    
    font = but.font
    fwidth  = font:getWidth( but.text) --Width of font
    fheight = font:getHeight(but.text) --Height of font
    tx = (but.w*but.sx - fwidth)/2     --Relative x position of font on textbox
    ty = (but.h*but.sy - fheight)/2 - fix     --Relative y position of font on textbox

    --Draws button text
    love.graphics.setColor(but.t_color.r, but.t_color.g, but.t_color.b, but.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(but.text, but.x + tx , but.y + ty)

end

--Draws a given image with text
function drawImg(img)
    local fwidth, fheight, tx, ty, font

    --Draws image
    love.graphics.setColor(255,255,255)
    love.graphics.draw(img.img, img.x, img.y, 0, img.sx, img.sy)
    
    font = img.font
    fwidth  = font:getWidth( img.text) --Width of font
    fheight = font:getHeight(img.text) --Height of font
    tx = (img.w*img.sx - fwidth)/2     --Relative x position of font on textbox
    ty = (img.h*img.sy - fheight)/2    --Relative y position of font on textbox

    --Draws image text
    love.graphics.setColor(img.t_color.r, img.t_color.g, img.t_color.b, img.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(img.text, img.x + tx , img.y + ty)

end


--Draws a given textbox
function drawTextBox(textbox)
    local fwidth, fheight, tx, ty, font

    --Draws textbox box
    love.graphics.setColor(textbox.b_color.r, textbox.b_color.g, textbox.b_color.b, textbox.b_color.a)
    love.graphics.rectangle("fill", textbox.x, textbox.y, textbox.w, textbox.h)
    
    fwidth  = textbox.font:getWidth(textbox.text)  --Width of font
    fheight = textbox.font:getHeight(textbox.text) --Height of font
    tx = (textbox.w - fwidth)/2                    --Relative x position of font on textbox
    ty = (textbox.h - fheight)/2                   --Relative y position of font on textbox

    --Draws textbox text
    font = textbox.font
    love.graphics.setColor(textbox.t_color.r, textbox.t_color.g, textbox.t_color.b, textbox.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(textbox.text, textbox.x + tx , textbox.y + ty)

end

--Draws a given text
function drawText(text)
    local font = text.font

    love.graphics.setColor(text.color.r, text.color.g, text.color.b, text.color.a)
    love.graphics.setFont(font)
    love.graphics.print(text.text, text.x, text.y, 0, text.sx, text.sy)

end

--Draws a given filter
function drawFilter(filter)

    love.graphics.setColor(filter.color.r, filter.color.g, filter.color.b, filter.color.a)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

end

--Draws a given particle
function drawParticle(particle)
    local r = particle.r --Particle radius

    love.graphics.setColor(particle.color.r, particle.color.g, particle.color.b, particle.color.a)
    love.graphics.circle("fill", particle.x, particle.y, r)

end

--Draws a given box
function drawBox(box)

    --Draws box
    love.graphics.setColor(box.color.r, box.color.g, box.color.b, box.color.a)
    love.graphics.draw(PIXEL, box.x, box.y, 0, box.w, box.h)

end

--Draws a given box with glow
function drawGlowBox(box)
    local eps = EPS_2

    --Draws box
    love.graphics.setColor(box.color.r, box.color.g, box.color.b, box.color.a)
    love.graphics.draw(PIXEL, box.x-eps, box.y-eps, 0, box.w+2*eps, box.h+2*eps)

end

--Draws a tile 
function drawTile(tile)
    local x, y, w, h
    
    w = TILESIZE
    h = TILESIZE
    x = BORDER + (tile.x - 1)*TILESIZE
    y = BORDER + (tile.y - 1)*TILESIZE

    --Draws tile
    love.graphics.setColor(tile.color.r, tile.color.g, tile.color.b, tile.color.a)
    love.graphics.draw(PIXEL, x, y, 0, w, h)

end

--Draws a glow effect for every tile
function drawGlowTile(tile)
    local x, y, w, h
    
    e = EPS   --Epsilon, range the glow effect will achieve
    w = TILESIZE
    h = TILESIZE
    x = BORDER + (tile.x - 1)*TILESIZE - e
    y = BORDER + (tile.y - 1)*TILESIZE - e

    --Draws tile
    love.graphics.setColor(tile.color.r, tile.color.g, tile.color.b, tile.color.a)
    love.graphics.draw(PIXEL, x, y, 0, w+2*e, h+2*e)

end


--Return functions
return pr