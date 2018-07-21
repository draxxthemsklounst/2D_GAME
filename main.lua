WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;
gameOver = false;


function love.load()
	love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true } )

  player = {}
  player.x = 200
  player.y = 560
  player.width = 30
  player.height = 30
  
  
  
end

function love.keyreleased(key)
  -- in v0.9.2 and earlier space is represented by the actual space character ' ', so check for both
  if (key == " " or key == "space") then
  
  elseif (key == "escape") then
    love.event.quit()
  end
end

function love.update(dt)
  if gameOver ~= false then
    love.draw()
  end

end

function love.draw()
  --Draws the floor
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle("fill",0,player.y + player.height,WINDOW_WIDTH,WINDOW_HEIGHT - player.y - player.height)
  
  --Draws the Player
  love.graphics.setColor(0,1,0)
	love.graphics.rectangle("fill",player.x,player.y,player.width,player.height)
  
  
  
end
