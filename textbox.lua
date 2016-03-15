--MODULE FOR TExtBox AND STUFF--

local textbox = {}

--Button object
TB = Class{
    init = function(self, x, y, w, h, text, font)
        self.x     = x     --x position
        self.y     = y     --y position
        self.w     = w     --width
        self.h     = h     --height
        self.text  = text  --text on button
        self.font  = font  --size of text
    end
}

function textbox.setup()
	--Button table
	TB_T = {}
	local x, y, w, h, font
	local gap = 5 --Gap between two buttons
	w = 160
	h = 60
	font = font_but_m

	--MAX_PLAYERS BUTTON
	x = 80
	y = 40
	max_player = TB(x, y, w, h, "MAX PLAYER", font)
	table.insert(TB_T, max_player)

end

--Return functions
return textbox