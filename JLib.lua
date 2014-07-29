
function init()
	lg = love.graphics
	
	window = {}
	window.width = lg.getWidth()
	window.height = lg.getHeight()
	
	nameColors()
	
	setButtons()
end

function jupdate(dt)
	fps = math.floor(1/dt)
	mx = love.mouse.getX()-(window.width/2)
	my = -love.mouse.getY()+(window.height/2)
end

function findIntersect(L1,L2)
--WIP*
--FIX THIS.
	L1.x1 = L1[1][1]
	L1.y1 = L1[1][2]
	L1.x2 = L1[2][1]
	L1.y2 = L1[2][2]
	
	L2.x1 = L2[1][1]
	L2.y1 = L2[1][2]
	L2.x2 = L2[2][1]
	L2.y2 = L2[2][2]
	--check for horizontal/vertical lines

	L1.slope = findSlope({L1.x1,L1.y1},{L1.x2,L1.y2})
	L2.slope = findSlope({L2.x1,L2.y1},{L2.x2,L2.y2})

	return L2.slope

end

function findSlope(p1,p2)

	--check if points are the same
	if (p1[1]==p2[1] and p1[2]==p2[2]) then
	
		return 0
	
	--check if line is vertical
	elseif (p1[1] == p2[1]) then
	
		return "inf"
	
	else
	
		return (p2[2]-p1[2])/(p2[1]-p1[1])
	
	end
	

end

--p2 is apex of angle
--p1=alpha/a, p2=gamma/c, p3=beta/b
function findAngle(p1,p2,p3)

	a = dist(p2,p3)
	b = dist(p1,p2)
	c = dist(p1,p3)
	
	--check for case where p1 is the same as p2
	if (p1[1]==p2[1] and p1[2]==p2[2]) then
	
		gamma = 0
		
	else
	
		gamma = math.acos( ((a^2)+(b^2)-(c^2)) / (2*a*b) )
		
	end
		
	return gamma

end

function dist(p1,p2)
	
	return math.sqrt( ((p2[1]-p1[1])^2) + ((p2[2]-p1[2])^2) )

end

function mergeTables(...)
	local arg = {...}

	merged = {}
	
	for i=1, #arg do
		for j, item in pairs(arg[i]) do
			table.insert(merged,item)
		end
	end
	
	return merged

end

function printTable(t)
	
	text = ""
	
	for i, item in pairs(t) do
			text = text..item.."\t"
	end
	
	print(text)
	
end

function pointLine(...)
	local arg = {...}
	
	lineTable = {}
	
	for i, tab in pairs(arg) do
		for j, point in pairs(tab) do
			lineTable = mergeTables(lineTable,point)
		end
	end
	
	lg.line(lineTable)

end

--arg[1] is type, rest are vertices
function pointPolygon(polyType,...)
	local arg = {...}
	
	polyTable = {}
	
	for i, tab in pairs(arg) do
		for j, point in pairs(tab) do
			polyTable = mergeTables(polyTable,point)
		end
	end
	
	lg.polygon(polyType,polyTable)

end

function adv(var, dist)

	return var + dist

end

function advCirc(var, dist, limit)
	
	retVal = (var+dist)%limit
	
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
	closestDist = dist(refPoint,arg[1][1])
	closestArg = 1
	closestTab = 1
	
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
function isInside(refPoint,poly)

	sumAngles = 0
	
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

function percentError(expected,obtained)

	return (math.abs(expected-obtained)/(expected))*100

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
	
	createButton("Test Button R",nil,"rectangle",17,18,100,50)
	buttons[#buttons].color = lime
	
	createButton("Test Button C",nil,"circle",8,8,7)
	buttons[#buttons].color = cerulean
	

end

function createButton(text,action,shape,...)
	local arg = {...}
	
	buttons[#buttons+1] = {}
	buttons[#buttons].shape = shape
	buttons[#buttons].text = text
	buttons[#buttons].action = action
	
	buttons[#buttons].color = "000000"
	buttons[#buttons].mouseOver = false
	buttons[#buttons].mouseOverText = text
	
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

function drawButtons()
--TODO: *Add text to buttons and optimize placement
--		*look for image and draw over if it exists
--		*Outline for buttons
	for i, button in pairs(buttons) do

		local RGB = HEXtoRGB(button.color)
		lg.setColor(RGB[1],RGB[2],RGB[3])
		
		if (button.shape == "rectangle") then
			lg.rectangle("fill",button.x,button.y,button.width,button.height)
		elseif (button.shape == "circle") then
			lg.circle("fill",button.x,button.y,button.radius)
		elseif (button.shape == "polygon") then
			pointPolygon("fill",button.p)
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
	
	alphaNumeric = "0123456789abcdef"
	
	majorNum = 0
	minorNum = 0
	
	while (DecNum>=16) do
		DecNum = DecNum - 16
		majorNum = majorNum + 1
	end
	
	minorNum = (DecNum % 16)
	
	return string.sub(alphaNumeric,(majorNum+1),(majorNum+1))..string.sub(alphaNumeric,(minorNum+1),(minorNum+1))
	
end

--converts 2 digit hexadecimal string to decimal integer
function HEXtoDEC(HexNum)

	alphaNumeric = "0123456789abcdef"
	
	majorNum = string.sub(HexNum, 1, 1)
	minorNum = string.sub(HexNum, 2, 2)
	
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
	
	cerulean = "007ba7"
	lime = "00ff00"
end