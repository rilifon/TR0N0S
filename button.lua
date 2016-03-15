--MODULE FOR BUTTONS AND STUFF--

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
	local x, y, w, h, font
	local gap = 5 --Gap between two buttons
	w = 160
	h = 60
	font = font_but_m

	--MAX_PLAYERS BUTTON
	x = 300
	y = 20
	max_player_up = But(x, y, w, h, "+", font, function()
																if MAX_PLAYERS < 4 then
																	MAX_PLAYERS = MAX_PLAYERS + 1
																end
															end)
	table.insert(B_T, max_player_up)
	max_player_down = But(x, y + h + gap, w, h, "-", font, function()
																if MAX_PLAYERS > 1 then
																	MAX_PLAYERS = MAX_PLAYERS - 1
																end
															end)
	table.insert(B_T, max_player_down)



end

--Check if a mouse click collides with any button
function button.checkCollision(x,y)
	for i,v in ipairs(B_T) do
		if 	v.x <= x
			and
			x <= v.x + v.w
			and
			v.y <= y
			and
			y <= v.y + v.h then

			v.func()
		end

	end
end


return button