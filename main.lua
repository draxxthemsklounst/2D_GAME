

--TO DO
--[[
  make obstacle object and obstacle object array
  make entity object and entity object array
  make a fire function and bullet array
]]

--global constants
  --Window
  local WINDOW_WIDTH = 1280;
  local WINDOW_HEIGHT = 720;

  --Game Logic
  local gameOver = false;
  local velocityPOSITIVE = true
  local obstacle = {}
  local tableObstacles = {}
  
  --Sprite Frames
  local playerRightImage
  local playerLeftImage
  local currentPlayerImage
  local playerRightFrames = {}
  local playerLeftFrames = {}
  local activeFrame
  local currentFrameIndex = 1
  local TOKEI = 0
  
  
function love.load()
	love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true } )
  
  love.graphics.setDefaultFilter('nearest','nearest')
  
  --environment
  gravityConstant = 0.5; 
  floorY = 700 --560
  
  --player "object"
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
  --spawns random obstacle
  obstacle:spawn()
  
  --idle sprite frame (by default start with right idle)
  playerRightImage = love.graphics.newImage("megamanIdleRIGHT.png")
  playerRightFrames[1] = love.graphics.newQuad(0,0,31,28,playerRightImage:getDimensions())
  playerRightFrames[2] = love.graphics.newQuad(0,28,31,28,playerRightImage:getDimensions())
  playerRightFrames[3]= love.graphics.newQuad(0,56,31,28,playerRightImage:getDimensions())
  currentPlayerImage = playerRightImage
  activeFrame = playerRightFrames[currentFrameIndex]
  
  playerLeftImage = love.graphics.newImage("megamanIdleLEFT.png")
  playerLeftFrames[1] = love.graphics.newQuad(0,0,31,28,playerLeftImage:getDimensions())
  playerLeftFrames[2] = love.graphics.newQuad(0,28,31,28,playerLeftImage:getDimensions())
  playerLeftFrames[3] = love.graphics.newQuad(0,56,31,28,playerLeftImage:getDimensions())
  
  
end


function obstacle:spawn()
  self.y = floorY
  self.x = 700
  self.width = 300
  self.height = 50
  table.insert(self,tableObstacles)
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
     velocityPOSITIVE = true
     currentPlayerImage = playerRightImage
     
  elseif love.keyboard.isDown("a") then
    player.xVelocity = -5
    velocityPOSITIVE = false
    currentPlayerImage = playerLeftImage
    

  end
  
  --PHYSICS UPDATE
  player.x = player.x + player.xVelocity -- any velocity is added to the displacement over time
  player.y = player.y + player.yVelocity -- any velocity is added to the displacement over time
  player.yVelocity = player.yVelocity + gravityConstant --gravity constantly present
  if player.y >= floorY then
    player.y = floorY
    player.yVelocity = 0
  end
  
  --X VELOCITY RESET (only when key is pressed)
  player.xVelocity = 0
  
  --SPRITE HANDLING
  TOKEI = TOKEI + dt
  if(TOKEI > 1) then
    if currentFrameIndex == 3 then
      currentFrameIndex = 1 --reset to first frame
    elseif currentFrameIndex < 3 then
      currentFrameIndex = currentFrameIndex + 1
    end
    
    if velocityPOSITIVE == true then
    activeFrame = playerRightFrames[currentFrameIndex] 
  elseif velocityPOSITIVE == false then
    activeFrame = playerLeftFrames[currentFrameIndex] 
  end
  
    TOKEI = 0
  end
end

function love.draw()
  --Draws the floor
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle("fill",0,floorY ,WINDOW_WIDTH,WINDOW_HEIGHT - floorY)
  
  --Draws the Player
  --if velocityPOSITIVE == true then
   -- love.graphics.draw(player.rightSprite,player.x,player.y - player.height + 4,0,1)
  --elseif velocityPOSITIVE ~= true then
    love.graphics.draw(currentPlayerImage,activeFrame,player.x,player.y - player.height * 3,0,3)
  --end
  
  --Player hitbox
  love.graphics.rectangle("line",player.x,player.y - player.height,player.width,player.height)

  --test obstacle
  love.graphics.rectangle("line",700,floorY-50,300,50)
  
  
end


