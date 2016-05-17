--MODULE FOR IMAGES AND STUFF--


local img = {}

--Button with image object
But_Img = Class{
    init = function(self, img, x, y, w, h, sx, sy, text, font, t_color, func)
        self.img   = img --Image
        self.x     = x     --x position of image
        self.y     = y     --y position of image
        self.c_x   = c_x   --x position of collision shape
        self.c_y   = c_y   --y position of collision shape
        self.w     = w     --width of collision shape
        self.h     = h     --height of collision shape
        self.sx    = sx     --scale x of image
        self.sy    = sy     --scale y of image

        self.text  = text  --text on button
        self.font  = font  --font of text

        --Color of text
        self.t_color = {}
        self.t_color.r = t_color.r
        self.t_color.g = t_color.g
        self.t_color.b = t_color.b
        self.t_color.a = t_color.a or 255

        --Color to paint image
        self.b_color = {}
        self.b_color.r = 255
        self.b_color.g = 255
        self.b_color.b = 255
        self.b_color.a = 255

        self.func  = func  --function to call when pressed
    end
}

--Button with image object
IMG = Class{
    init = function(self, img, x, y, w, h, sx, sy, text, font, t_color)
        self.img   = img --Image
        self.x     = x     --x position of image
        self.y     = y     --y position of image
        self.c_x   = c_x   --x position of collision shape
        self.c_y   = c_y   --y position of collision shape
        self.w     = w     --width of collision shape
        self.h     = h     --height of collision shape
        self.sx    = sx     --scale x of image
        self.sy    = sy     --scale y of image

        self.text  = text  --text on button
        self.font  = font  --font of text

        --Color of text
        self.t_color = {}
        self.t_color.r = t_color.r
        self.t_color.g = t_color.g
        self.t_color.b = t_color.b
        self.t_color.a = t_color.a or 255

        --Color to paint image
        self.b_color = {}
        self.b_color.r = 255
        self.b_color.g = 255
        self.b_color.b = 255
        self.b_color.a = 255

    end
}

--Checks if a mouse click collides with any image
function img.checkCollision(x,y)
    local but = nil

    --Iterate on default "buttons with image" table
    for i,b in pairs(BI_T) do
        if  b.x < x
            and
            x < b.x + b.w*b.sx
            and
            b.y < y
            and
            y < b.y + b.h*b.sy
        then
            --Click is within image "box". Now checking by pixel position
            if checkPixelCollision(b.img, (x-b.x), (y-b.y)) then
                but = b.func
            end
        end
    end

    --Iterate on HUD table
    for i,b in pairs(HUD_T) do
        if  b.x < x
            and
            x < b.x + b.w*b.sx
            and
            b.y < y
            and
            y < b.y + b.h*b.sy
        then
            --Click is within image "box". Now checking by pixel position
            if checkPixelCollision(b.img, (x-b.x), (y-b.y)) then
                but = b.func
            end
        end
    end

    --Do respective functions
    if but then but() end

end

--Checks if the relative NORMALIZED x,y position is colored
function checkPixelCollision(img, x, y)
    local img_data, r, g, b, a 

    img_data = img:getData()
    r, g, b, a  = img_data:getPixel(x,y)
    if r ~= 0 or
       g ~= 0 or
       b ~= 0
    then
        return true
    end
    
    return false
end


--Return functions
return img