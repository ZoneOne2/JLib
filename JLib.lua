
function init()
	lg = love.graphics
	
	window = {}
	window.width = lg.getWidth()
	window.height = lg.getHeight()
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
	
	for i=1, #arg do
		lineTable = mergeTables(lineTable,arg[i])
	end
	
	lg.line(lineTable)

end

--arg[1] is type, rest are vertices
function pointPolygon(...)
	local arg = {...}
	
	polyTable = {}
	
	for i=2, #arg do
		polyTable = mergeTables(polyTable,arg[i])
	end
	
	lg.polygon(arg[1],polyTable)

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
--arg[1] is point in question, rest are possible points
function findClosestPoint(...)
	local arg = {...}
	
	p = {}
	p[1] = arg[1][1]
	p[2] = arg[1][2]
	
	printTable(t1)
	printTable(t2)
	printTable(t3)

	--start by assuming first in points list (arg[2]) is closest
	closest = {arg[2][1], arg[2][2]}
	

	
	closestDist = dist(p,arg[2])


	
	--next check 3 through...
	for i=3, #arg do
	
		if (dist(p,arg[i]) < closestDist) then
			closest = {arg[i][1], arg[i][2]}
			closestDist = dist(p,arg[i])
		end
	
	end
	
	return closest

end




function pause()

	print("Paused.")
	
	
	while(true)do end
	
end