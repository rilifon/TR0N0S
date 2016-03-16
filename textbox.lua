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
        --Color of text
        self.t_color = {}
        self.t_color.r = t_color.r
        self.t_color.g = t_color.g
        self.t_color.b = t_color.b        

    end
}

function textbox.setup()
	--Default TextBox table
	DTB_T = {}
	
	local x, y, w, h, font
	local color_b = COLOR(233, 131, 0)
	local color_t = COLOR(0, 0, 0)
	w = 240
	h = 60
	font = font_but_m

	--N_PLAYERS BUTTON
	x = 40
	y = 40
	n_player = TB(x, y, w, h, "NUMBER OF PLAYERS", font, color_b, color_t)
	table.insert(DTB_T, n_player)

end

--Return functions
return textbox