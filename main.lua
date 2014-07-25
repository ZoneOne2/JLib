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
	
	
	lg.pop()

end

function love.update(dt)
	
	mx = love.mouse.getX()-(window.width/2)
	my = -love.mouse.getY()+(window.height/2)
	
	allPoints = mergeTables(t.polygon,t.angle,t.center)

	t1 = {mx,my}
	t2 = {97,5}
	t3 = {26,31}
	
	

	--test = findClosestPoint(t1,t2,t3)

	print(pointTypes[activePointType],findClosestPoint(t1,allPoints))
	
	--pause()
	
end

function love.focus(bool)
end

function love.keypressed( key, unicode )
	if key == "tab" then
		activePointType = advCirc(activePointType,1,#pointTypes)
	end
end

function love.keyreleased( key, unicode )
end

function love.mousepressed( x, y, button )
	
	if button == "l" then
	
		table.insert(t[pointTypes[activePointType]],{mx, my})
	
	end

end

function love.mousereleased( x, y, button )
end

function love.quit()
end
