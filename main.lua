WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;
gameOver = false;


function love.load()
	love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true } )

  love.graphics.setDefaultFilter('nearest','nearest')
  
  
  gravityConstant = 0.5; 
  floorY = 560

  player = {}
  player.x = 200
  player.y = 560
  player.xVelocity = 0
  player.yVelocity = 0
  player.width = 30
  player.height = 30
  player.rightSprite = love.graphics.newImage('megamanRIGHT.png')
  player.leftSprite = love.graphics.newImage('megamanLEFT.png')
  player.jump = function()
    if player.y == floorY then
      player.yVelocity = -8
    end
  end
  
  
  
  
end

function love.keypressed(key)
  -- in v0.9.2 and earlier space is represented by the actual space character ' ', so check for both
  
  if (key == "escape") then
    love.event.quit()
  end
end



function love.update(dt)
  --END CHECKER
  if gameOver ~= false then
    love.draw()
  end
  
  --KEYBOARD INPUT
  if love.keyboard.isDown("space") then
    player.jump()
  end
  if love.keyboard.isDown("d") then
    player.xVelocity = 5
elseif love.keyboard.isDown("a") then
    player.xVelocity = -5
  end
  
  --PHYSICS UPDATE
  player.x = player.x + player.xVelocity
  player.y = player.y + player.yVelocity
  player.yVelocity = player.yVelocity + gravityConstant
  if player.y == floorY then
    player.yVelocity = 0
  end
  
  --VELOCITY RESET
  player.xVelocity = 0
end

function love.draw()
  --Draws the floor
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle("fill",0,floorY ,WINDOW_WIDTH,WINDOW_HEIGHT - floorY)
  
  --Draws the Player
  --love.graphics.setColor(0,0,0)
  if player.xVelocity > 0 then
	love.graphics.draw(player.rightSprite,player.x,player.y - player.height + 4,0,1)
elseif player.xVelocity < 0 then
  love.graphics.draw(player.leftSprite,player.x,player.y - player.height + 4,0,1)
  end
  love.graphics.rectangle("line",player.x,player.y - player.height,player.width,player.height)

  
  
  
end


