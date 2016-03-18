--MODULE FOR TEXT AND STUFF--

local text = {}

--TextBox object
TXT = Class{
    init = function(self, x, y, text, font, color)
        self.x       = x       --x position
        self.y       = y       --y position
        self.text    = text    --text on button
        self.font    = font    --size of text
        
        --Color of text
        self.color = {}
        self.color.r = color.r
        self.color.g = color.g
        self.color.b = color.b
        if color.a then
            self.color.a = color.a
        else
            self.color.a = 255
        end

    end
}

--Return functions
return textbox