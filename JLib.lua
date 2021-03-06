debugJLib = false
function printJLib(toPrint)
	if debugJLib then
		print(toPrint)
	end
 end


function init()
	nameColors()
	lg = love.graphics

	joysticks = love.joystick.getJoysticks()
	axes = {}

	for i, joystick in pairs(joysticks) do
	
		axes[i] = {}
	
	 end

	defaultFont = love.graphics.newFont(12)
	smallFont = love.graphics.newFont(10)
	smallestFont = love.graphics.newFont(8)
	love.graphics.setFont(defaultFont)
	
	window = {}
	window.width = lg.getWidth()
	window.height = lg.getHeight()

	userInput = {}

	Button = {

		id = 0,
		name = "untitled",
		text = "button",
		image = nil,
		backgroundColor = white,
		textColor = black,
		x = 0,
		y = 0,
		width = 100,
		height = 50,
		action = nil,

	 }
	function Button:new(o)

		o = o or {}
		setmetatable(o, self)
		self.__index = self

		o.bounds = getButtonBounds(o)

		return o

	 end

	buttons = {}

	player = {

		x = -100,
		y = 50,
		width = 20,
		height = 20,
		bounds = { {x=-10,y=10},{x=10,y=10},{x=10,y=-10},{x=-10,y=-10} },
		ax = 0,
		ay = 0,
		vx = 0,
		vy=0,
		speed = 100,
		onGround = false,
		gravity = 250

	 }

	wall = {

		{ {x=-500,y=10},{x=500,y=10},{x=500,y=-10},{x=-500,y=-10} }

	}
	
	setButtons()

	zoomLevel = 1
	zoomOffsetX = 0
	zoomOffsetY = 0

	hasTextInput = false
	love.keyboard.setTextInput(false)

	mode = "none"

 end

function jupdate(dt)

	fps = math.floor(1/dt)

	updateCursor()

	for i, joystick in pairs(joysticks) do
	
		axes[i] = {joystick:getAxes()}

		for j, axis in pairs(axes[i]) do
	
			if (math.abs(axis)<0.3) then
			
				axes[i][j] = 0
			
			 end
	
		 end
	
	 end

	--axes = {joysticks[1]:getAxes()}

	

 end

function updateCursor()

	mxw = love.mouse.getX()
	myw = love.mouse.getY()

	mx = (mxw-zoomOffsetX)/zoomLevel
	my = (myw-zoomOffsetY)/zoomLevel

	mouse = {x=mx, y=my}

 end

function findPerpendicular(vector,length)
	
	length = length or 1

	local ux = vector[1].x
	local uy = vector[1].y

	local vx = vector[2].x
	local vy = vector[2].y

	local vMag = math.sqrt((vx-ux)^2+(vy-uy)^2)
	local unitX = (vx-ux)/vMag
	local unitY = (vy-uy)/vMag

	local px = unitY
	local py = -unitX

	return {{x=ux,y=uy},{x=ux+length*px,y=uy+length*py}}

 end

function perpendicularBisector(vector,length)
	length = length or 1
	
	local side1 = findPerpendicular(vector,-length/2)
	local side2 = findPerpendicular(vector,length/2)

	return {{x=side1[2].x,y=side1[2].y},{x=side2[2].x,y=side2[2].y}}

 end


function findIntersect(L1,L2,ends)	

	if(ends == nil) then
		endsCount = true
	else
		endsCount = ends
	end

	local x1 = L1[1].x
	local y1 = L1[1].y
	local x2 = L1[2].x
	local y2 = L1[2].y

	--make sure point1 is always the bottom-leftmost point.
	if (x2 < x1) then

		x1 = L1[2].x
		y1 = L1[2].y
		x2 = L1[1].x
		y2 = L1[1].y

	 elseif (x2 == x1) then

		if (y2 < y1) then

			x1 = L1[2].x
			y1 = L1[2].y
			x2 = L1[1].x
			y2 = L1[1].y

		 end

	 end

	local m1 = findSlope({x=x1,y=y1},{x=x2,y=y2})
	local b1 = y1-(m1*x1)



	local x3 = L2[1].x
	local y3 = L2[1].y
	local x4 = L2[2].x
	local y4 = L2[2].y

	--make sure point1 is always the bottom-leftmost point.
	if (x4 < x3) then

		x3 = L2[2].x
		y3 = L2[2].y
		x4 = L2[1].x
		y4 = L2[1].y

	 elseif (x4 == x3) then

		if (y4 < y3) then

			x3 = L2[2].x
			y3 = L2[2].y
			x4 = L2[1].x
			y4 = L2[1].y

		 end

	 end

	local m2 = findSlope({x=x3,y=y3},{x=x4,y=y4})
	local b2 = y3-(m2*x3)

	local xInt,yInt,intercept

	--special case for if one of the lines is really just a point
	--doesn't worry about endsCount
	if ( (L1[1].x == L1[2].x) and (L1[1].y == L1[2].y) ) then
		printJLib("Line 1 is really just a point")
		if isOnLine(L1[1],L2) then
			return true, {x=L1[1].x,y=L1[1].y}
		else
			return false, {x=inf, y=inf}
		end
	elseif ( (L2[1].x == L2[2].x) and (L2[1].y == L2[2].y) ) then
		printJLib("Line 2 is really just a point")
		if isOnLine(L2[1],L1) then
			return true, {x=L2[1].x,y=L2[1].y}
		else
			return false, {x=inf, y=inf}
		end
	end





	--special case if slope is the same
	if (m1 == m2) then

		if ( isOnLine({x=x1,y=y1},L2) ) then

			printJLib("same slope, intersection found (1)")
			return true, {x=x1, y=y1}

		elseif ( isOnLine({x=x2,y=y2},L2) ) then

			printJLib("same slope, intersection found (2)")
			return true, {x=x2,y=y2}

		else

			printJLib("same slope, no intersection found")
			return false, {x=inf, y=inf}

		 end

	 end

	
	--case for ends counting as intersection
	if (endsCount) then
		
		--special case for L1 = vertical line
		if (m1 == "inf") then

			if (x3<=x1 and x4>=x2) then

				xInt = x1
				yInt = (m2*xInt)+b2

				if (not isInRange(yInt,y1,y2)) then
				
					printJLib("m1 = infinite slope, no intersection found")
					return false, {x=inf, y=inf}
				
				 end

			 else

				printJLib("m1 = infinite slope, no intersection found")
				return false, {x=inf, y=inf}

			 end

		--special case for L2 = vertical line
		elseif (m2 == "inf") then

			if (x1<=x3 and x2>=x4) then

				xInt = x3
				yInt = (m1*xInt)+b1

				if (not isInRange(yInt,y3,y4)) then
				
					printJLib("m1 = infinite slope, no intersection found")
					return false, {x=inf, y=inf}
				
				 end

			 else

				printJLib("m2 = infinite slope, no intersection found")
				return false, {x=inf, y=inf}

			 end

		--normal case
		else

			xInt = (b2-b1)/(m1-m2)
			yInt = m1*xInt+b1

		end

	--case for ends not counting as intersection
	else

		--special case for L1 = vertical line
		if (m1 == "inf") then

			if (x3<x1 and x4>x2) then

				xInt = x1
				yInt = (m2*xInt)+b2

				if (not isInRange(yInt,y1,y2) or yInt==y1 or yInt==y2) then
				
					printJLib("m1 = infinite slope, no intersection found")
					return false, {x=inf, y=inf}
				
				 end

			 else

				printJLib("m1 = infinite slope, no intersection found")
				return false, {x=inf, y=inf}

			 end

		--special case for L2 = vertical line
		elseif (m2 == "inf") then

			if (x1<x3 and x2>x4) then

				xInt = x3
				yInt = (m1*xInt)+b1

				if (not isInRange(yInt,y3,y4) or yInt==y3 or yInt==y4) then
				
					printJLib("m1 = infinite slope, no intersection found")
					return false, {x=inf, y=inf}
				
				 end

			 else

				printJLib("m2 = infinite slope, no intersection found")
				return false, {x=inf, y=inf}

			 end

		--normal case
		else

			xInt = (b2-b1)/(m1-m2)
			yInt = m1*xInt+b1

		end

	end

	--stupid possible floating point error correction
	if (percentError(x1,xInt)<1e-5) then
		xInt = x1
	 elseif (percentError(x2,xInt)<1e-5) then
		xInt = x2
	 elseif (percentError(x3,xInt)<1e-5) then
		xInt = x3	
	 elseif (percentError(x4,xInt)<1e-5) then
		xInt = x4
	 end
	if (percentError(y1,yInt)<1e-5) then
		yInt = y1
	 elseif (percentError(y2,yInt)<1e-5) then
		yInt = y2
	 elseif (percentError(y3,yInt)<1e-5) then
		yInt = y3	
	 elseif (percentError(y4,yInt)<1e-5) then
		yInt = y4
	 end
	
	intercept = {x=xInt,y=yInt}


	--case for ends counting as intersection
	if (endsCount) then

		if ( (xInt >= x1) and (xInt <= x2) and (xInt >= x3) and (xInt <= x4) ) then

			return true, intercept

		else

			return false, intercept

		end

	--case for ends not counting as intersection
	else


		if ( (xInt > x1) and (xInt < x2) and (xInt > x3) and (xInt < x4) ) then
		--	printJLib((xInt>x1),"xint",xInt,"x1,x2",x1,x2,"x3,x4",x3,x4)
			return true, intercept

		else

			return false, intercept

		end

	end


 end

function findSlope(point1,point2)

	--check to make sure points contain x and
	local p1,p2

	if (point1.x and point1.y) then

		p1 = {x=point1.x, y=point1.y}

	 else

		error("point 1 is missing x and/or y")

	 end

	if (point2.x and point2.y) then

		p2 = {x=point2.x, y=point2.y}

	 else

		error("point 2 is missing x and/or y")

	 end

	--check if points are the same
	if (p1.x==p2.x and p1.y==p2.y) then
	
		return 0
	
	--check if line is vertical
	elseif (p1.x == p2.x) then
	
		printJLib("vertical line found")
		return "inf"
	
	 else
	
		return (p2.y-p1.y)/(p2.x-p1.x)
	
	 end
	

 end

--p2 is apex of angle
--p1=alpha/a, p2=gamma/c, p3=beta/b
function findAngle(point1,point2,point3)

	--check to make sure points contain x and y
	local p1,p2,p3

	if (point1.x and point1.y) then

		p1 = {x=point1.x, y=point1.y}

	 else

		error("point 1 is missing x and/or y")

	 end

	if (point2.x and point2.y) then

		p2 = {x=point2.x, y=point2.y}

	 else

		error("point 2 is missing x and/or y")

	 end

	if (point3.x and point3.y) then

		p3 = {x=point3.x, y=point3.y}

	 else

		error("point 3 is missing x and/or y")

	 end

	local a = dist(p2,p3)
	local b = dist(p1,p2)
	local c = dist(p1,p3)
	local gamma = 0
	
	--check for case where p1 is the same as p2
	if (p1.x==p2.x and p1.y==p2.y) then
	
		gamma = 0
	
	--else compute gamma	
	else
	
		gamma = math.acos( ((a^2)+(b^2)-(c^2)) / (2*a*b) )
		
	 end
		
	return gamma

 end

function dist(point1,point2)

	--check to make sure points contain x and y
	local p1,p2

	if (point1.x and point1.y) then

		p1 = {x=point1.x, y=point1.y}

	 else

		error("point 1 is missing x and/or y")

	 end

	if (point2.x and point2.y) then

		p2 = {x=point2.x, y=point2.y}


	 else

		error("point 2 is missing x and/or y")

	 end

	return math.sqrt( ((p2.x-p1.x)^2) + ((p2.y-p1.y)^2) )

 end

function mergeTables(...)
	local arg = {...}

	local merged = {}
	
	for i=1, #arg do

		for j, item in pairs(arg[i]) do

			table.insert(merged,item)

		 end

	 end
	
	return merged

 end

function printTable(t)
	
	local text = ""
	
	for i, item in pairs(t) do

		text = text..item.."\t"

	 end
	
	print(text)
	
 end

function pointLine(...)
	local arg = {...}
	
	local lineTable = {}
	
	for i, tab in pairs(arg) do

		for j, point in pairs(tab) do

			table.insert(lineTable,point.x)
			table.insert(lineTable,point.y)

		 end

	 end
	
	lg.line(lineTable)

 end

--arg[1] is type, rest are vertices
function pointPolygon(polyType,...)
	local arg = {...}
	
	local polyTable = {}
	
	for i, tab in pairs(arg) do

		for j, point in pairs(tab) do

			table.insert(polyTable,point.x)
			table.insert(polyTable,point.y)

		 end

	 end
	
	lg.polygon(polyType,polyTable)

 end

function adv(var, dist)

	return var + dist

 end

function advCirc(var, dist, limit)
	
	local retVal = (var+dist)%limit
	
	if retVal == 0 then
	
		return limit
	
	else
	
		return retVal
		
	 end

 end

--takes tables of points
--refPoint is point in question, rest of args are tables containing possible points
--returns[1] table from passed args that contains closest point
--returns[2] element from table in returns[1] that is the closet point
function findClosestPoint(refPoint,...)
	local arg = {...}
	
	--closest = {arg[1][1][1], arg[1][1][2]}
	local closestDist = dist(refPoint,arg[1][1])
	local closestArg = 1
	local closestTab = 1
	
	for i, tab in pairs(arg) do

		for j, point in pairs(tab) do

			if (dist(refPoint,point)<closestDist) then

				--closest = {point[1], point[2]}
				closestDist = dist(refPoint,point)
				closestArg = i
				closestTab = j

			 end

		 end

	 end
	
	return {arg[closestArg],closestTab}

 end

function pause()

	print("Paused.")
	
	
	while(true)do end
	
 end

function drawGrid(scale)

	lg.setColor(200,200,200)
	lg.setLineWidth(1)
	
	--right
	for i=0, window.width/2, scale do

		lg.line(i,window.height/2,i,-window.height/2)

	 end
	
	--left, start at -scale since 0 was already done in right
	for i=-scale, -window.width/2, -scale do

		lg.line(i,window.height/2,i,-window.height/2)

	 end
	
	--top
	for i=0, window.height/2, scale do

		lg.line(window.width/2,i,-window.width/2,i)

	 end
	
	--bottom, start at -scale since 0 was already done in top
	for i=-scale, -window.height/2, -scale do

		lg.line(window.width/2,i,-window.width/2,i)

	 end
	
 end


function setColorFind(seeking)

	lg.setColor(colorFind.R[seeking],colorFind.G[seeking],colorFind.B[seeking])

 end

--refPoint is point in question, poly is table containing points representing polygon that point is/is not inside
--TODO: Add variables number of arguments for multiple tables containing points
function isInside(refPoint,poly)

	local sumAngles = 0
	
	--check to see if refPoint is one of the points making up the polygon
	for i, point in pairs(poly) do

		if ( (refPoint.x == point.x) and (refPoint.y == point.y)) then

			return true

		 end

	 end

	--if refPoint isn't one of the points making up the polygon, check to see if it is a point enclosed by it
	for i, point in pairs(poly) do
		
		--add angles made from (point-refPoint-nextPoint) for each point
		
		--nextPoint for lastpoint (poly[#poly]) is firstpoint (poly[1])
		if (i == #poly) then

			sumAngles = sumAngles + findAngle(point,refPoint,poly[1])

		 else

			sumAngles = sumAngles + findAngle(point,refPoint,poly[i+1])

		 end

	 end
	
	--tolerance for %error here:
	if (percentError(2*math.pi,sumAngles)<1e-5) then

		return true

	 else

		return false

	 end

 end

--xq,yq are x and y for point in question (refPoint)
--TODO: general function for rearranging points to go in order with bottom-leftmost first?
function isOnLine(refPoint,line)

	local lineSlope = findSlope(line[1],line[2])

	local x1 = line[1].x
	local y1 = line[1].y
	local x2 = line[2].x
	local y2 = line[2].y

	local xq = refPoint.x
	local yq = refPoint.y

	
	--make sure point1 is always the bottom-leftmost point.
	if (x2 < x1) then

		x1 = line[2].x
		y1 = line[2].y
		x2 = line[1].x
		y2 = line[1].y

	 elseif (x2 == x1) then

		if (y2 < y1) then

			x1 = line[2].x
			y1 = line[2].y
			x2 = line[1].x
			y2 = line[1].y

		 end

	 end



	--check for vertical line case
	if (lineSlope == "inf") then

		if (x1 == xq) then

			if ( (yq>=y1) and (yq<=y2) ) then

				return true

			 else

				return false

			 end

		 else

			return false

		 end

	 end


	--if not vertical line, check to see if point is on line
	if( percentError((yq-y1),(lineSlope*(xq-x1))) < 1e-5 ) then
	--if ( (yq-y1) == (lineSlope*(xq-x1)) ) then

		--check to make sure it's in the bounds of the line
		if ( (xq>=x1) and (xq<=x2) ) then

			return true

		 else
		 	

			return false

		 end

	 else

		return false

	 end

 end

function percentError(expected,obtained)

	if (expected == 0) then
		if(obtained == 0) then
			return 0
		else
			expected = 1e-9
		end	
	end
	return math.abs(((expected-obtained)/(expected))*100)

 end

--[[PLACE IN main.lua for specific project

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

]]

function getButtonBounds(button)

	local p1 = {x=button.x,y=button.y}
	local p2 = {}
	local p3 = {}
	local p4 = {}

	p2 = {x=(button.x+button.width),y=(button.y)}
	p3 = {x=(button.x+button.width),y=(button.y-button.height)}
	p4 = {x=(button.x),y=(button.y-button.height)}

	return {p1,p2,p3,p4}

 end

--...: x,y of top-left corner for rectangle
--[[function createButton(text,action,shape,...)
	local arg = {...}
	
	buttons[#buttons+1] = {
		shape = shape,
		text = text,
		action = action,
		
		color = "000000",
		mouseOver = false,
		mouseOverText = text,
	}
	
	
	if (shape == "polygon") then

		buttons[#buttons].p = arg[1]

	elseif (shape == "rectangle") then

		buttons[#buttons].x = arg[1]
		buttons[#buttons].y = arg[2]
		buttons[#buttons].width = arg[3]
		buttons[#buttons].height = arg[4]

	elseif (shape == "circle") then

		buttons[#buttons].x = arg[1]
		buttons[#buttons].y = arg[2]
		buttons[#buttons].radius = arg[3]

	 end

 end
]]
function drawButtons()
--TODO: mouse-over text
--		add shape for image
--		remove polygon shape
	for i, button in pairs(buttons) do

		lg.push()
			lg.translate(button.x,button.y)
			--lg.scale(1,-1)

			local textWidth = defaultFont:getWidth(button.text)
			local textHeight = defaultFont:getHeight(button.text)

			setHexColor(button.backgroundColor)

			if (button.image ~= nil) then

				button.width = button.image:getWidth()
				button.height = button.image:getHeight()

				setHexColor(white)
				lg.draw(button.image,0,0)

			else

				lg.rectangle("fill",0,0,button.width,button.height)

			 end

			setHexColor(button.textColor)
			lg.print(button.text,(button.width/2)-(textWidth/2),(button.height/2)-(textHeight/2))
		
		 lg.pop()
	
	 end

 end

function checkButtonPress()

	for i, button in pairs(buttons) do

		if ( isInside(mouse,button.bounds) ) then

			button.action()

		 end

	 end

 end

function RGBtoHEX(R, G, B)

	return DECtoHEX(R)..DECtoHEX(G)..DECtoHEX(B)

 end

function HEXtoRGB(hex)
	
	return { HEXtoDEC(string.sub(hex,1,2)), HEXtoDEC(string.sub(hex,3,4)), HEXtoDEC(string.sub(hex,5,6)) }
	
 end

function DECtoHEX(DecNum)
	
	local alphaNumeric = "0123456789abcdef"
	
	local majorNum = 0
	local minorNum = 0
	
	while (DecNum>=16) do

		DecNum = DecNum - 16
		majorNum = majorNum + 1

	 end
	
	minorNum = (DecNum % 16)
	
	return string.sub(alphaNumeric,(majorNum+1),(majorNum+1))..string.sub(alphaNumeric,(minorNum+1),(minorNum+1))
	
 end

--converts 2 digit hexadecimal string to decimal integer
function HEXtoDEC(HexNum)

	local alphaNumeric = "0123456789abcdef"
	
	local majorNum = string.sub(HexNum, 1, 1)
	local minorNum = string.sub(HexNum, 2, 2)
	
	for i=1, #alphaNumeric, 1 do
	
		if (majorNum == string.sub(alphaNumeric, i, i)) then

			majorNum = i-1

		 end
		
		if (minorNum == string.sub(alphaNumeric, i, i)) then

			minorNum = i-1

		 end
	
	 end

	return ((16*majorNum)+minorNum)
	
 end

function nameColors()

	red = "ff0000"
	orange = "ffa500"
	yellow = "ffff00"
	green = "008000"
	blue = "0000ff"
	purple = "800080"
	
	white = "ffffff"
	black = "000000"
	gray = "808080"
	grey = "808080"
	brown = "a52a2a"
	
	cerulean = "007ba7"
	lime = "00ff00"
	cyan = "00ffff"
	magenta = "ff00ff"
	hotPink = "ff69b4"

	gold = "ffd700"
	silver = "c0c0c0"
	bronze = "cd7f32"
	platinum = "e5e4e2"

	honoluluBlue = "006db0"
	lionsBlue = "006db0"

	gryffindorRed = "c40001"
	gryffindorGold = "f39f00"
	slytherinGreen = "004101"
	slytherinSilver = "dcdcdc"
	hufflepuffYellow = "fff300"
	hufflepuffBlack = "000000"

 end

function setHexColor(hexColor,alpha)

	local RGB = HEXtoRGB(hexColor)

	local a = alpha or 255

	lg.setColor(RGB[1],RGB[2],RGB[3],a)

 end

function testFunc() 

	for n in pairs(_G) do print(n,_G[n]) end

 end


function tableMin(tab)

	local firstPass = true
	local minVal
	local minKey

	for i, element in pairs(tab) do

		if (firstPass) then

			minKey = i
			minVal = element
			firstPass = false

		else

		 	if (element < minVal) then

		 		minKey = i
		 		minVal = element

		 	 end

		 end

	 end

	 return minVal,minKey

 end

function tableMax(tab)

	local firstPass = true
	local maxVal
	local maxKey

	for i, element in pairs(tab) do

		if (firstPass) then

			maxKey = i
			maxVal = element
			firstPass = false

		else

		 	if (element > maxVal) then

		 		maxKey = i
		 		maxVal = element

		 	 end

		 end

	 end

	 return maxVal,maxKey

 end

--takes a table of objects and sorts them based on certain field
--sorts lowest to highest
function objectTableSort(tab,field)

	if (type(field) ~= "string") then

		error("Field passed to objectTableSort was not a string.")

	 end

	for i, Obj1 in pairs(tab) do

		for j, Obj2 in pairs(tab) do

			if (tab[j][field]>tab[i][field]) then

				tab[i], tab[j] = tab[j], tab[i]
				--print("swapped "..Obj2.id.." with "..Obj1.id)

			 end

		 end

	 end

 end

function findMid(point1,point2)

	--check to make sure points contain x and
	local p1,p2

	if (point1.x and point1.y) then

		p1 = {x=point1.x, y=point1.y}

	 else

		error("point 1 is missing x and/or y")

	 end

	if (point2.x and point2.y) then

		p2 = {x=point2.x, y=point2.y}

	 else

		error("point 2 is missing x and/or y")

	 end

	return {(p1.x+p2.x)/2, (p1.y+p2.y)/2}
	

 end

function isInTable(val,tab)

	for i, element in pairs(tab) do

		if (element == val) then

			return true

		 end

	 end

	return false

 end

function findAreaTriangle(point1,point2,point3)

 --check to make sure points contain x and y
	local p1,p2,p3

	if (point1.x and point1.y) then

		p1 = {x=point1.x, y=point1.y}

	 else

		error("point 1 is missing x and/or y")

	 end

	if (point2.x and point2.y) then

		p2 = {x=point2.x, y=point2.y}

	 else

		error("point 2 is missing x and/or y")

	 end

	if (point3.x and point3.y) then

		p3 = {x=point3.x, y=point3.y}

	 else

		error("point 3 is missing x and/or y")

	 end

	local a = dist(p2,p3)
	local b = dist(p1,p3)
	local c = dist(p1,p2)
	local gamma = findAngle(p2,p3,p1)
	local h = a*math.sin(gamma)
	
	return 0.5*b*h


 end

--xq,yq are x and y for point in question (refPoint)
--TODO: general function for rearranging points to go in order with bottom-leftmost first? (originated in isOnLine())
		--DOESN'T WORK WELL FOR ANGLES > 90°
function distToLine(refPoint,line)

	local x1 = line[1].x
	local y1 = line[1].y
	local x2 = line[2].x
	local y2 = line[2].y

	local xq = refPoint.x
	local yq = refPoint.y

	
	--make sure point1 is always the bottom-leftmost point.
	if (x2 < x1) then

		x1 = line[2].x
		y1 = line[2].y
		x2 = line[1].x
		y2 = line[1].y

	 elseif (x2 == x1) then

		if (y2 < y1) then

			x1 = line[2].x
			y1 = line[2].y
			x2 = line[1].x
			y2 = line[1].y

		 end

	 end


	local alpha = findAngle({x=xq,y=yq},{x=x1,y=y1},{x=x2,y=y2})
	local b = dist({x=xq,y=yq},{x=x1,y=y1})

	return b*math.sin(alpha)

 end



function textInput(name,x,y)

	love.keyboard.setTextInput(true)
	prevMode = mode
	activeText = name
	hasTextInput = true

	userInput[activeText] = ""
	textX = x
	textY = y

 end




function drawText(text,x,y)

	--lg.push()
	lg.translate(x,y)
	--lg.scale(1,-1)
		lg.print(text,0,0)
	--lg.pop()

 end




function zoom(increment)


	local mxBeforeZoom = mx
	local myBeforeZoom = my

	zoomLevel = zoomLevel*increment

	updateCursor()
	
	local mxAfterZoom = mx
	local myAfterZoom = my

	zoomOffsetX = zoomOffsetX + (mxAfterZoom-mxBeforeZoom)*zoomLevel
	zoomOffsetY = zoomOffsetY + (myAfterZoom-myBeforeZoom)*zoomLevel


 end



--returns position (key) for a spicified value in a table.
--If value exists more than once, only the first key will be returned.
function getKey(val,table)


	for i, value in pairs(table) do

		if (value == val) then

			return i

		 end

	 end

	print("Value not found, no key given.")
	return nil

 end


function drawDebug()
	local debugText = "FPS:"..fps.."\nX:"..love.mouse.getX().."\nY:"..love.mouse.getY()
	local textWidth = defaultFont:getWidth(debugText)
	local textHeight = defaultFont:getHeight(debugText)

	setHexColor(white)
	love.graphics.print( debugText, 0, window.height-3*textHeight )
	--love.graphics.printf( debugText, 0, -textHeight, window.width )


end

function isInRange(val,end1,end2)

	local min = math.min(end1,end2)
	local max = math.max(end1,end2)

	if (val<=max and val>=min) then

		return true

	else
	
		return false
	
	end

end
--





































































