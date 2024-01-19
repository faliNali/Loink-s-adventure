
local heart1, heart2, heart3 = 2

function heartsUpdate()
  if loink.health >= 6 then
    heart1 = 2
    heart2 = 2
    heart3 = 2
  elseif loink.health >= 5 then
    heart1 = 1
    heart2 = 2
    heart3 = 2
  elseif loink.health >= 4 then
    heart1 = 0
    heart2 = 2
    heart3 = 2
  elseif loink.health >= 3 then
    heart1 = 0
    heart2 = 1
    heart3 = 2
  elseif loink.health >= 2 then
    heart1 = 0
    heart2 = 0
    heart3 = 2
  elseif loink.health >= 1 then
    heart1 = 0
    heart2 = 0
    heart3 = 1
  else
    heart1 = 0
    heart2 = 0
    heart3 = 0
  end
  
end


function heartsDraw()
  if heart1 == 2 then
    love.graphics.draw(misc_spriteSheet, full_quad, -camera.X + love.graphics.getWidth() - 300, -camera.Y + 10, 0, 6, 6)
  elseif heart1 == 1 then
    love.graphics.draw(misc_spriteSheet, half_quad, -camera.X + love.graphics.getWidth() - 300, -camera.Y + 10, 0, 6, 6)
  else
    love.graphics.draw(misc_spriteSheet, empty_quad, -camera.X + love.graphics.getWidth() - 300, -camera.Y + 10, 0, 6, 6)
  end
  
  if heart2 == 2 then
    love.graphics.draw(misc_spriteSheet, full_quad, -camera.X + love.graphics.getWidth() - 200, -camera.Y + 10, 0, 6, 6)
  elseif heart2 == 1 then
    love.graphics.draw(misc_spriteSheet, half_quad, -camera.X + love.graphics.getWidth() - 200, -camera.Y + 10, 0, 6, 6)
  else
    love.graphics.draw(misc_spriteSheet, empty_quad, -camera.X + love.graphics.getWidth() - 200, -camera.Y + 10, 0, 6, 6)
  end
  
  if heart3 == 2 then
    love.graphics.draw(misc_spriteSheet, full_quad, -camera.X + love.graphics.getWidth() - 100, -camera.Y + 10, 0, 6, 6)
  elseif heart3 == 1 then
    love.graphics.draw(misc_spriteSheet, half_quad, -camera.X + love.graphics.getWidth() - 100, -camera.Y + 10, 0, 6, 6)
  else
    love.graphics.draw(misc_spriteSheet, empty_quad, -camera.X + love.graphics.getWidth() - 100, -camera.Y + 10, 0, 6, 6)
  end
  
end
