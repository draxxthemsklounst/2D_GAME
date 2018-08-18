

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
  local currentFrameIndexBegin = 1
  local currentFrameIndexEnd = 3    --initialize the initial frames to the idle sprites
  local time = 0
  local timeSinceInput = 0
  
  
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
  player.width = 50
  player.height = 50
  player.rightSprite = love.graphics.newImage('megamanRIGHT.png')
  player.leftSprite = love.graphics.newImage('megamanLEFT.png')
  player.jump = function()
    if player.y == floorY then
      player.yVelocity = -8
    end
  end
  --spawns random obstacle
  obstacle:spawn()
  
  --load player sprites left and right
  playerRightImage = love.graphics.newImage("masterSpriteRight.png")
  playerLeftImage = love.graphics.newImage("masterSpriteLeft.png")
  
-- ALL RIGHT SPRITE  

  --idle standing right
  playerRightFrames[1] = love.graphics.newQuad(0,0,50,50,playerRightImage:getDimensions())
  playerRightFrames[2] = love.graphics.newQuad(50,0,50,50,playerRightImage:getDimensions())
  playerRightFrames[3]= love.graphics.newQuad(100,0,50,50,playerRightImage:getDimensions())
  currentPlayerImage = playerRightImage
  activeFrame = playerRightFrames[currentFrameIndex]
  
  --running right
  playerRightFrames[4] = love.graphics.newQuad(150,0,50,50,playerRightImage:getDimensions())
  playerRightFrames[5] = love.graphics.newQuad(200,0,50,50,playerRightImage:getDimensions())
  playerRightFrames[6] = love.graphics.newQuad(250,0,50,50,playerRightImage:getDimensions())
  
  
--ALL LEFT SPRITE

  --idle standing left
  playerLeftFrames[1] = love.graphics.newQuad(0,0,50,50,playerLeftImage:getDimensions())
  playerLeftFrames[2] = love.graphics.newQuad(50,0,50,50,playerLeftImage:getDimensions())
  playerLeftFrames[3]= love.graphics.newQuad(100,0,50,50,playerLeftImage:getDimensions())
  
  --running left
  playerLeftFrames[4] = love.graphics.newQuad(150,0,50,50,playerLeftImage:getDimensions())
  playerLeftFrames[5] = love.graphics.newQuad(200,0,50,50,playerLeftImage:getDimensions())
  playerLeftFrames[6] = love.graphics.newQuad(250,0,50,50,playerLeftImage:getDimensions())
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
       timeSinceInput = 0
       if(time > 0.3) then
         activeFrame = playerRightFrames[currentFrameIndex]
        end
       
       
    elseif love.keyboard.isDown("a") then
      player.xVelocity = -5
      velocityPOSITIVE = false
      currentPlayerImage = playerLeftImage
      timeSinceInput = 0
      if(time > 0.3) then
         activeFrame = playerLeftFrames[currentFrameIndex]
        end

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
  time = time + dt
  timeSinceInput = timeSinceInput + dt
  
  
    if love.keyboard.isDown("d") then
      
      --the start and end frames of the running sprite
      currentFrameIndexBegin = 4
      currentFrameIndexEnd = 6
      activeFrame = playerRightFrames[currentFrameIndex] 
      
    elseif love.keyboard.isDown("a") then
      
      --the start and end frames of the running sprite
      currentFrameIndexBegin = 4
      currentFrameIndexEnd = 6
      activeFrame = playerLeftFrames[currentFrameIndex] 
      
    end
    if velocityPOSITIVE == true then
      activeFrame = playerRightFrames[currentFrameIndex]
    elseif velocityPOSITIVE == false then
      activeFrame = playerLeftFrames[currentFrameIndex]
    end
    
  if(time > 0.3) then
    
    if timeSinceInput >= 3 then --if idle for 3 seconds, idle frames will play
      if currentFrameIndex == 3 then
        currentFrameIndex = 1 --reset to first frame
      elseif currentFrameIndex < 3 then
        currentFrameIndex = currentFrameIndex + 1
      end
    end
    time = 0
  end
  
  if (time > 0.3) then
    if currentFrameIndex == currentFrameIndexEnd then
      currentFrameIndex = currentFrameIndexBegin
    elseif currentFrameIndex < currentFrameIndexEnd then
      currentFrameIndex = currentFrameIndex + 1
    end
    time = 0
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
    love.graphics.draw(currentPlayerImage,activeFrame,player.x,player.y - 50 + 12 ,0,1)
  --end
  
  --Player hitbox
  love.graphics.rectangle("line",player.x,player.y - player.height,player.width,player.height)

  --test obstacle
  love.graphics.rectangle("line",700,floorY-50,300,50)
  
  
end


