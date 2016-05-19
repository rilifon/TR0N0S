--MODULE FOR TEXTBOX AND STUFF--

local textbox = {}

--TextBox object
TB = Class{
    init = function(self, x, y, w, h, text, font, b_color, t_color)
        self.x       = x       --x position
        self.y       = y       --y position
        self.w       = w       --width
        self.h       = h       --height
        self.text    = text    --text on button
        self.font    = font    --size of text
        --Color of box
        self.b_color = {}
        self.b_color.r = b_color.r
        self.b_color.g = b_color.g
        self.b_color.b = b_color.b
        self.b_color.a = b_color.a or 255

        --Color of text
        self.t_color = {}
        self.t_color.r = t_color.r
        self.t_color.g = t_color.g
        self.t_color.b = t_color.b
        self.t_color.a = t_color.a or 255
        
    end
}

--Return functions
return textbox