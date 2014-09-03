function keyPressed(key,unicode)

	if key == "d" then

		player.vx = player.vx + player.speed

	 end

	if key == "a" then

		player.vx = player.vx + -player.speed

	 end

	if key == "w" then
		
		if player.onGround then
			player.vy = 100
		 end

	 end

 end

function keyReleased(key,unicode)

	if key == "d" then

		player.vx = player.vx - player.speed

	 end

	if key == "a" then

		player.vx = player.vx + player.speed

	 end

 end







 