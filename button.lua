--MODULE FOR BUTTONS AND STUFF--


local button = {}

--Button object
But = Class{
	init = function(self, x, y, w, h, text, font, b_color, t_color, func)
		self.x     = x     --x position
		self.y     = y     --y position
		self.w     = w     --width
		self.h     = h     --height
		self.text  = text  --text on button
	    self.font  = font  --font of text
	    --Color of box
        self.b_color = {}
        self.b_color.r = b_color.r
        self.b_color.g = b_color.g
        self.b_color.b = b_color.b
        if b_color.a then
        	self.b_color.a = b_color.a
        else
        	self.b_color.a = 255
        end
        --Color of text
        self.t_color = {}
        self.t_color.r = t_color.r
        self.t_color.g = t_color.g
        self.t_color.b = t_color.b
        if t_color.a then
        	self.t_color.a = t_color.a
        else
        	self.t_color.a = 255
        end

		self.func  = func  --function to call when pressed
	end
}


--Check if a mouse click collides with any button
function button.checkCollision(x,y)
	local but = nil
	local p_but = nil

	--Disables buttons if player is typing
	if BUTTON_LOCK then return end --If buttons are locked, does nothing

	--Iterate on default buttons table
	for i,b in pairs(B_T) do
		if 	b.x <= x
			and
			x <= b.x + b.w
			and
			b.y <= y
			and
			y <= b.y + b.h then

			but = b.func
		end
	end

	--Iterate on players buttons table
	for i,b in pairs(PB_T) do
		if 	b.x <= x
			and
			x <= b.x + b.w
			and
			b.y <= y
			and
			y <= b.y + b.h then

			p_but = b.func
		end
	end

	--Do respective functions
	if but then but() end
	if p_but then p_but() end

end


return button