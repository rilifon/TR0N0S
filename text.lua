--MODULE FOR TEXT AND STUFF--

local text = {}

--TextBox object
TXT = Class{
    init = function(self, x, y, text, font, color, sx, sy)
        self.x       = x       --x position
        self.y       = y       --y position
        self.text    = text    --text on button
        self.font    = font    --size of text
        
        --Color of text
        self.color = {}
        self.color.r = color.r
        self.color.g = color.g
        self.color.b = color.b
        self.color.a = color.a or 255

        self.sx = sx or 1 --Scale x of text
        self.sy = sy or 1 --Scale y of text

        self.w = self.font:getWidth(self.text)  --Width of text
        self.h = self.font:getHeight(self.text) --Height of text

    end
}

--Return functions
return textbox