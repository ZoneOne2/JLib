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

	testAudio = love.audio.newSource("GoodMorningTucson.mp3")
	
	
	t = {}
	t.polygon = {}
	t.angle = {}
	t.center = {}

 end

function love.draw()

	lg.push()
	
		
	
		lg.scale(1,-1)
		lg.translate(window.width/2,-window.height/2)

		
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
			
				lg.circle("fill",point[1],point[2],1)
				
			 end
			
		 end
		
		if (#t.polygon>2) then
			pointPolygon("line",t.polygon)
		 end
		
		if (#t.angle==2) then
			pointLine(t.angle)
		 end

		drawButtons()
	
	
	 lg.pop()

 end

function love.update(dt)
	
	jupdate(dt)
	
	allPoints = mergeTables(t.polygon,t.angle,t.center)

	t1 = {}
	t1[1] = {mx,my}
	t2 = {}
	t2[1] = {97,5}
	t3 = {}
	t3[1] = {26,31}
	
	if (#t.angle==2) then
		lineTest = {
					{t.angle[1][1],t.angle[1][2]},
					{t.angle[2][1],t.angle[2][2]}
					}
		print(fps,pointTypes[activePointType],mx,my,isOnLine(t1[1],lineTest))
	 else
		print(fps,pointTypes[activePointType],mx,my)
	 end

 end

function love.focus(bool)

 end

function love.keypressed( key, unicode )

	if key == "tab" then

		activePointType = advCirc(activePointType,1,#pointTypes)

	 end

	if key == "`" then

		debug.debug()

	 end

 end

function love.keyreleased( key, unicode )

 end

function love.mousepressed( x, y, button )
	
	if button == "l" then
	
		table.insert(t[pointTypes[activePointType]],{mx, my})

		checkButtonPress()
	
	 end
	
	if button == "r" then
		--TODO: only works if at least one polygon point exists, why?
		forRemove = findClosestPoint({mx,my},t.polygon,t.angle,t.center)
		table.remove(forRemove[1],forRemove[2])
	
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
	
	createButton("Test Button R",testFunc,"rectangle",0,0,100,30)
	buttons[#buttons].color = lime
	buttons[#buttons].image = love.graphics.newImage("test.png")
	buttons[#buttons].bounds = getButtonBounds(buttons[#buttons])

	--100x30
	
	--createButton("Test Button C",nil,"circle",8,8,7)
	--buttons[#buttons].color = cerulean
	

 end