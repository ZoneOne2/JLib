
function init()
	lg = love.graphics
	
	window = {}
	window.width = lg.getWidth()
	window.height = lg.getHeight()
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