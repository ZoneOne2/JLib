function love.load()

	require "JLib"
	
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
	
		
	
		lg.scale(1,-1)
		lg.translate(window.width/2,-window.height/2)

		lg.translate(zoomOffsetX,zoomOffsetY)
		lg.scale(zoomLevel)
		
		drawGrid(50)

		
		
		lg.setLineWidth(1)

		
		lg.setColor(255,0,0)
		lg.circle("fill",0,0,10)
		
		lg.setColor(0,255,0)
		lg.circle("fill",100,0,10)
		
		lg.setColor(0,0,255)
		lg.circle("fill",100,100,10)

		lg.setColor(255,0,255)
		lg.circle("fill",0,100,10)
		
	
		lg.setColor(0,255,0)
		pointLine(t1,t2)
		pointLine(t2,t3)
		
		lg.setColor(255,0,0)
		--pointPolygon("line",t1,t2,t3)
		
		for i, typeOfPoint in pairs(t) do
		
			setColorFind(i)
			for j, point in pairs(typeOfPoint) do
			
				lg.circle("fill",point.x,point.y,1)
				
			 end
			
		 end
		
		if (#t.polygon>2) then
			pointPolygon("line",t.polygon)
			print(findAreaTriangle(t.polygon[1],t.polygon[2],t.polygon[3]))
		 end
		
		if (#t.angle==2) then
			pointLine(t.angle)
		 end

		--if (#t.polygon == 2 and #t.center == 2) then

			pointLine(testLine1)
			pointLine(testLine2)

			--if (intTest) then
				setHexColor(red)
				lg.circle("fill",intPoint.x,intPoint.y,3)
			--end

		--end

		drawButtons()
	
		if (hasTextInput) then

			local textWidth = defaultFont:getWidth(userInput[activeText])
			local textHeight = defaultFont:getHeight(userInput[activeText])

			setHexColor(white)
			lg.rectangle("fill",textX-1,textY+1,textWidth+2,-textHeight-2)
			setHexColor(black)
			lg.rectangle("line",textX-1,textY+1,textWidth+2,-textHeight-2)

			setHexColor(cerulean)
			drawText(userInput[activeText],textX,textY)

		 end
	
	 lg.pop()

 end

function love.update(dt)
	
	jupdate(dt)
	
	allPoints = mergeTables(t.polygon,t.angle,t.center)

	t1 = {}
	t1[1] = {x=mx,y=my}
	t2 = {}
	t2[1] = {x=97,y=5}
	t3 = {}
	t3[1] = {x=26,y=31}
	
	--[[
	if (#t.angle==2) then
		lineTest = {
					{x=t.angle[1].x,y=t.angle[1].y},
					{x=t.angle[2].x,y=t.angle[2].y}
					}
		print(fps,pointTypes[activePointType],mx,my,isOnLine(t1[1],lineTest))
	 else
		print(fps,pointTypes[activePointType],mx,my,distToLine(t1[1],{t2[1],t3[1]}))
	 end

	testTable = {1,9,8,4,key1 = -100, key2 = (100*math.pi),0,2,4,-98.5}

	--print(tableMin(testTable))

	dist({x=0,y=0},mouse)

	]]


	--if (#t.polygon == 2 and #t.center == 2) then
		testLine1 = {{x=228,y=131},{x=-27,y=100}}
		testLine2 = {{x=-27,y=230},{x=202,y=-145}}
		intTest, intPoint = findIntersect(testLine1,testLine2,false)
		print(fps,pointTypes[activePointType],mx,my,mode,love.keyboard.isDown("capslock"))
	
	-- else

		--print(fps,pointTypes[activePointType],mx,my)

	-- end

	testTablezzz = {2,4,key1 = "test",5}


 end

function love.focus(bool)

 end

function love.textinput(t)

	userInput[activeText] = userInput[activeText]..t

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


	 end



 end

function love.keyreleased( key, unicode )

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