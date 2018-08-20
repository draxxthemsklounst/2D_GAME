

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
  local VPSTRING = "true"
  
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
  local timeSinceKeyPress 
  local playerState = "IDLE_RIGHT"
  local spriteRate = 0.5 --the "fps"
function createPlayer()
  
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
  
  return player
end


function love.load()
	love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true } )
  
  love.graphics.setDefaultFilter('nearest','nearest')
  
  --environment
  gravityConstant = 0.5; 
  floorY = 700 --560
  
  player = createPlayer()
  
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
  
  --jump right
  playerRightFrames[7] = love.graphics.newQuad(300,0,50,50,playerRightImage:getDimensions())
--ALL LEFT SPRITE

  --idle standing left
  playerLeftFrames[1] = love.graphics.newQuad(0,0,50,50,playerLeftImage:getDimensions())
  playerLeftFrames[2] = love.graphics.newQuad(50,0,50,50,playerLeftImage:getDimensions())
  playerLeftFrames[3]= love.graphics.newQuad(100,0,50,50,playerLeftImage:getDimensions())
  
  --running left
  playerLeftFrames[4] = love.graphics.newQuad(150,0,50,50,playerLeftImage:getDimensions())
  playerLeftFrames[5] = love.graphics.newQuad(200,0,50,50,playerLeftImage:getDimensions())
  playerLeftFrames[6] = love.graphics.newQuad(250,0,50,50,playerLeftImage:getDimensions())
  
  --jump left
  playerLeftFrames[7] = love.graphics.newQuad(300,0,50,50,playerLeftImage:getDimensions())
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
    
    --KEYBOARD INPUT
    if love.keyboard.isDown("space") then
      
      player.jump()
      if velocityPOSITIVE == true and playerState ~= "JUMPING_RIGHT" then
          currentFrameIndex = 7
          currentFrameIndexBegin = 7
          currentFrameIndexEnd = 7
          spriteRate = 0
          activeFrame = playerRightFrames[currentFrameIndex]
          playerState = "JUMPING_RIGHT"
        
        
      elseif velocityPOSITIVE == false and playerState ~= "JUMPING_LEFT" then
          currentFrameIndex = 7
          currentFrameIndexBegin = 7
          currentFrameIndexEnd = 7
          spriteRate = 0
          activeFrame = playerLeftFrames[currentFrameIndex]
          playerState = "JUMPING_LEFT"
        
        
      end
        
      
    end
  
    if love.keyboard.isDown("d") then
      timeSinceInput = 0
      player.xVelocity = 5
      velocityPOSITIVE = true
      VPSTRING = "true"
      currentPlayerImage = playerRightImage
      spriteRate = 0.12
      
      if (playerState ~= "RUNNING_RIGHT" and player.y == floorY )then --STATE CHECKER
        currentFrameIndex = 4
        currentFrameIndexBegin = 4
        currentFrameIndexEnd = 6
        activeFrame = playerRightFrames[currentFrameIndex]
        playerState = "RUNNING_RIGHT"
      end
      
      
       
    elseif love.keyboard.isDown("a") then
        timeSinceInput = 0
        player.xVelocity = -5
        velocityPOSITIVE = false
        VPSTRING = "false"
        currentPlayerImage = playerLeftImage
        timeSinceInput = 0
        spriteRate = 0.12
        
        if (playerState ~= "RUNNING_LEFT" and player.y == floorY) then --STATE CHECKER
          currentFrameIndex = 4
          currentFrameIndexBegin = 4
          currentFrameIndexEnd = 6
          activeFrame = playerLeftFrames[currentFrameIndex]
          playerState = "RUNNING_LEFT"
        end
        
        
    end
  
    
    --SWITCH TO IDLE AFTER RUNNING CHECKER
    if timeSinceInput > 0 then
      if playerState == "RUNNING_RIGHT" then
        playerState = "IDLE_RIGHT"
        currentFrameIndex = 1
        currentFrameIndexBegin = 1
        currentFrameIndexEnd = 3
        activeFrame = playerRightFrames[currentFrameIndex]
      elseif playerState == "RUNNING_LEFT" then
        playerState = "IDLE_LEFT"
        currentFrameIndex = 1
        currentFrameIndexBegin = 1
        currentFrameIndexEnd = 3
        activeFrame = playerLeftFrames[currentFrameIndex]
      end

      spriteRate = 0.5
      
    end
    
    if player.y == floorY and playerState == "JUMPING_RIGHT" or player.y == floorY and playerState == "JUMPING_LEFT" then
        if velocityPOSITIVE == true then
          currentFrameIndex = 1
          currentFrameIndexBegin = 1
          currentFrameIndexEnd = 3
          activeFrame = playerRightFrames[currentFrameIndex]
          playerState = "IDLE_RIGHT"
      elseif velocityPOSITIVE == false then
          currentFrameIndex = 1
          currentFrameIndexBegin = 1
          currentFrameIndexEnd = 3
          activeFrame = playerLeftFrames[currentFrameIndex]
          playerState = "IDLE_LEFT"
        end
      end
      
    
    --ANIMATION LOOP
    time = time + dt
    timeSinceInput = timeSinceInput + dt
    if (time > spriteRate) then
      --[[
      ]]
      if currentFrameIndex == currentFrameIndexEnd then
        currentFrameIndex = currentFrameIndexBegin
      elseif currentFrameIndex < currentFrameIndexEnd then
        currentFrameIndex = currentFrameIndex + 1
      end
      
      if playerState == "RUNNING_RIGHT"  or playerState =="IDLE_RIGHT" or playerState == "JUMPING_RIGHT" then
        activeFrame = playerRightFrames[currentFrameIndex]
      elseif playerState == "RUNNING_LEFT" or playerState =="IDLE_LEFT" or playerState == "JUMPING_LEFT"then
        activeFrame = playerLeftFrames[currentFrameIndex]
      else
        activeFrame = playerRightFrames[currentFrameIndex]
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
    love.graphics.draw(currentPlayerImage,activeFrame,player.x,player.y - 50 + 12-145,0,5)
  --end
  
  --Player hitbox
  love.graphics.rectangle("line",player.x,player.y - player.height,player.width,player.height)

  --test obstacle
  love.graphics.rectangle("line",700,floorY-50,300,50)
  
  --prints some variables to help debugging
  love.graphics.print("Player State: " ..playerState..
                    "\nPlayer X: " ..player.x..
                    "\nPlayer Y: " ..player.y..
                    "\nPlayer X Velocity: " ..player.xVelocity..
                    "\nPlayer Y Velocity: " .. player.yVelocity..
                    "\nVelocity Positive: " ..VPSTRING..
                    "\nSprite Speed: " ..spriteRate,50,50)
  
end


