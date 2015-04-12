function love.load()

	require "JLib"
	require "keys"
	require "buttons"
	
	





	init()
	
	pointTypes = {"polygon", "angle", "center"}
	activePointType = 1
	
	colorFind = {}
	colorFind.R = {}
	colorFind.G = {}
	colorFind.B = {}
	
	colorFind.R.polygon = 255
	colorFind.G.polygon = 0
	colorFind.B.polygon = 0
	
	colorFind.R.angle = 0
	colorFind.G.angle = 255
	colorFind.B.angle = 0
	
	colorFind.R.center = 0
	colorFind.G.center = 0
	colorFind.B.center = 255

	testAudio = love.audio.newSource("test.mp3")
	testImage = love.graphics.newImage("test.png")
	
	t = {}
	t.polygon = {}
	t.angle = {}
	t.center = {}


	TestObj = {
				id = 0,
				testField = 0,
			 }
	function TestObj:new(o)

		totalTestObjs = totalTestObjs+1

		o = o or {}
		setmetatable(o, self)
		self.__index = self
		o.id = #testObjs+1
		return o

	 end
	totalTestObjs = 0



	testObjs = {}

	table.insert(testObjs,TestObj:new{testField = 18})
	table.insert(testObjs,TestObj:new{testField = 7})
	table.insert(testObjs,TestObj:new{testField = -78})
	table.insert(testObjs,TestObj:new{testField = 0})
	table.insert(testObjs,TestObj:new{testField = math.pi})
	table.insert(testObjs,TestObj:new{testField = 720})
	table.insert(testObjs,TestObj:new{testField = -18.9})
	table.insert(testObjs,TestObj:new{testField = 8.6})

 end

function love.draw()

	lg.push()
	
		
	
		--lg.scale(1,-1)
		--lg.translate(window.width/2,-window.height/2)

		lg.translate(zoomOffsetX,zoomOffsetY)
		lg.scale(zoomLevel)
		
		setHexColor(cerulean)
		love.graphics.circle( "fill", window.width/2, window.height/2, 2 )
		love.graphics.circle( "fill", mouse.x, mouse.y, 2 )

		setHexColor(red)
		pointLine(testVector)
		setHexColor(lime)
		pointLine(bisec)
	
	 lg.pop()

 end

function love.update(dt)
	jupdate(dt)

	testVector = {{x=window.width/2,y=window.height/2},mouse}
	pVec = findPerpendicular(testVector,-50)
	bisec = perpendicularBisector(testVector,100)
	print(dist(bisec[1],bisec[2]))


 end

function love.focus(bool)

 end

function love.textinput(t)

	userInput[activeText] = userInput[activeText]..t

end

function love.gamepadpressed( joystick, button )

	buttonPressed(joystick,button)

 end

function love.gamepadreleased( joystick, button)

	buttonReleased(joystick,button)

 end

function love.keypressed( key, unicode )



	if (hasTextInput) then


		if key == "backspace" then

			userInput[activeText] = string.sub(userInput[activeText],1,-2)

		 elseif (key == "kpenter") or (key == "return") then

		 	love.keyboard.setTextInput(false)
		 	hasTextInput = false
		 	activeText = ""

		 end
	 

	else



		if key == "tab" then

			activePointType = advCirc(activePointType,1,#pointTypes)

		 end

		if key == "`" then

			debug.debug()

		 end


		keyPressed(key,unicode)


	 end



 end

function love.keyreleased( key, unicode )

	keyReleased(key,unicode)

 end

function love.mousepressed( x, y, button )
	
	
	if (button == "wu") then

		zoom(1.5)

	 end

	if (button == "wd") then

		zoom((1/1.5))

	 end












	if button == "l" then
	
		table.insert(t[pointTypes[activePointType]],{x=mx, y=my})

		checkButtonPress()
	
	 end
	
	if button == "r" then
		--TODO: only works if at least one polygon point exists, why?
		forRemove = findClosestPoint({mx,my},t.polygon,t.angle,t.center)
		table.remove(forRemove[1],forRemove[2])
	
	 end


	if button == "m" then

		textInput("testField",mx,my)

	 end

 end

function love.mousereleased( x, y, button )

 end

function love.quit()

 end


function setButtons()


	buttons = {}
	
	--shape: rectangle, circle, or polygon
		--rectangle:
			--x: top-left corner x-coordinate
			--y: top-left corner y-coordinate
			--width: button width
			--height: button height
		--circle:
			--x: center x-coordinate
			--y: center y-coordinate
			--width: button radius
		--polygon:
			--p: table containing points
				--p[1]: x
				--p[2]: y
	--color: color of button
	--image: image of button (if one exists)
	--text: text to display on button
	--mouseOver: true/false for mouseover text
	--mouseOverText: text to display on mouseover if mouse-over is true
	--action: function to execute upon click
	
	buttons[1] = Button:new{

		text = "Test Button R",
		action = testFunc,
		x=0, y=0,
		width = 100, height = 30,
		backgroundColor = lime,
		textColor = red,
		--image = lg.newImage("test.png")

	 }
	--(createButton("Test Button R",testFunc,"rectangle",0,0,100,30)
	--buttons[#buttons].color = lime
	--buttons[#buttons].image = love.graphics.newImage("test.png")
	--buttons[#buttons].bounds = getButtonBounds(buttons[#buttons])

	--100x30
	
	--createButton("Test Button C",nil,"circle",8,8,7)
	--buttons[#buttons].color = cerulean
	

 end