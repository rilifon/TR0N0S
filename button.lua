--MODULE FOR BUTTONS--

local button = {}

--Button object
But = Class{
	init = function(self, x, y, w, h, text, font, func)
		self.x     = x     --x position
		self.y     = y     --y position
		self.w     = w     --width
		self.h     = h     --height
		self.text  = text  --text on button
	    self.font  = font  --size of text
		self.func  = func  --function to call when pressed
	end
}

function button.setup()
	--Button table
	B_T = {}
	max_player_up = But(80,40,160,60, "max player", font_but_m, function()
																if MAX_PLAYERS < 4 then
																	MAX_PLAYERS = MAX_PLAYERS + 1
																end
															end)
	table.insert(B_T, max_player_up)
end




return button