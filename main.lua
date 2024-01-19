
function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  gamestate = 'playing'
  gameFont = love.graphics.newFont('sprites/Minecraft-regular.otf', 40)
  love.graphics.setFont(gameFont)
  loink_spriteSheet = love.graphics.newImage('sprites/loink.png')
  misc_spriteSheet = love.graphics.newImage('sprites/misc.png')
  enemy_spriteSheet = love.graphics.newImage('sprites/enemy.png')
  anim8 = require('libraries/anim8-master/anim8')
  bump = require('libraries/bump-master/bump')
  sti = require('libraries/Simple-Tiled-Implementation-master/sti')
  flux = require('libraries/flux-master/flux');
  world = bump.newWorld(22.5)
  hyroolMap = sti('maps/hyrool.lua')
  full_quad = love.graphics.newQuad(0, 0, 15, 15, misc_spriteSheet:getWidth(), misc_spriteSheet:getHeight())
  half_quad = love.graphics.newQuad(15, 0, 15, 15, misc_spriteSheet:getWidth(), misc_spriteSheet:getHeight())
  empty_quad = love.graphics.newQuad(30, 0, 15, 15, misc_spriteSheet:getWidth(), misc_spriteSheet:getHeight())
  explosion_quad = love.graphics.newQuad(0, 15, 15, 15, misc_spriteSheet:getWidth(), misc_spriteSheet:getHeight())
  spearUp_quad = love.graphics.newQuad(0, 30, 15, 15, misc_spriteSheet:getWidth(), misc_spriteSheet:getHeight())
  spearRight_quad = love.graphics.newQuad(15, 30, 15, 15, misc_spriteSheet:getWidth(), misc_spriteSheet:getHeight())
  spearDown_quad = love.graphics.newQuad(30, 30, 15, 15, misc_spriteSheet:getWidth(), misc_spriteSheet:getHeight())
  spearLeft_quad = love.graphics.newQuad(45, 30, 15, 15, misc_spriteSheet:getWidth(), misc_spriteSheet:getHeight())
  rock_quad = love.graphics.newQuad(15, 15, 15, 15, misc_spriteSheet:getWidth(), misc_spriteSheet:getHeight())
  loinkShield_quad = love.graphics.newQuad(0, 210, 30, 30, loink_spriteSheet:getWidth(), loink_spriteSheet:getHeight())
  loinkSprites = {}
  loinkSprites.grid = anim8.newGrid(30, 30, loink_spriteSheet:getWidth(), loink_spriteSheet:getHeight())
  loinkSprites.down = anim8.newAnimation(loinkSprites.grid('1-4', 1), 0.15)
  loinkSprites.left = anim8.newAnimation(loinkSprites.grid('1-2', 2), 0.15)
  loinkSprites.right = anim8.newAnimation(loinkSprites.grid('3-4', 2), 0.15)
  loinkSprites.up = anim8.newAnimation(loinkSprites.grid('1-4', 3), 0.15)
  loinkSprites.swordDown = anim8.newAnimation(loinkSprites.grid('1-4', 4), 0.05)
  loinkSprites.swordLeft = anim8.newAnimation(loinkSprites.grid('1-4', 5), 0.05)
  loinkSprites.swordRight = anim8.newAnimation(loinkSprites.grid('1-4', 6), 0.05)
  loinkSprites.swordUp = anim8.newAnimation(loinkSprites.grid('1-4', 7), 0.05)
  enemyGrid = anim8.newGrid(15, 15, enemy_spriteSheet:getWidth(), enemy_spriteSheet:getHeight())
  squidSprites = {}
  squidSprites.down = anim8.newAnimation(enemyGrid('1-2', 1), 0.2)
  squidSprites.up = anim8.newAnimation(enemyGrid('1-2', 2), 0.2)
  squidSprites.right = anim8.newAnimation(enemyGrid('1-2', 3), 0.2)
  squidSprites.left = squidSprites.right:clone():flipH()
  pigSprites = {}
  pigSprites.down = anim8.newAnimation(enemyGrid('3-4', 1), 0.2)
  pigSprites.up = anim8.newAnimation(enemyGrid('3-4', 2), 0.2)
  pigSprites.right = anim8.newAnimation(enemyGrid('3-4', 3), 0.2)
  pigSprites.left = pigSprites.right:clone():flipH()
  itemGrid = anim8.newGrid(15, 15, misc_spriteSheet:getWidth(), misc_spriteSheet:getHeight())
  itemSprites = {}
  itemSprites.heart = anim8.newAnimation(itemGrid('1-2', 4), 0.2)
  
  require('loink')
  require('hud/text')
  require('hud/hearts')
  require('items/heart')
  require('enemies/squid')
  require('enemies/pig')
  require('sword')
  require('proj')
  require('npc')
  
  for i, w in pairs(hyroolMap.layers['Walls'].objects) do
    world:add(w, w.x, w.y, w.width, w.height)
  end
  
  for i, s in pairs(hyroolMap.layers['squid spawns'].objects) do
    newSquid(s.x, s.y)
  end
  
  for i, p in pairs(hyroolMap.layers['pig spawns'].objects) do
    newPig(p.x, p.y)
  end
  
  camera = {}
  camera.X = -loink.X + love.graphics.getWidth() / 2 - 45
  camera.Y = -loink.Y + love.graphics.getHeight() / 2 - 45
  
  explosions = {}
  explosionTimer = 0.1
  
  heartNPC = newNPC(hyroolMap.layers['loink starting point'].objects[1].x - 45, hyroolMap.layers['loink starting point'].objects[1].y - 45, misc_spriteSheet, full_quad, half_quad, {'oof', 'OOF', ""})
end


function love.update(dt)
  if gamestate == 'playing' then
    loinkUpdate(dt)
    camera.X = -loink.X + love.graphics.getWidth() / 2 - 45
    camera.Y = -loink.Y + love.graphics.getHeight() / 2 - 45
    if camera.X > 0 then
      camera.X = 0
    end
    
    if camera.X < -9000 + love.graphics.getWidth() then
      camera.X = -9000 + love.graphics.getWidth()
    end
    
    if camera.Y > 0 then
      camera.Y = 0
    end
    
    if camera.Y < -6750 + love.graphics.getHeight() then
      camera.Y = -6750 + love.graphics.getHeight()
    end
    
    
    
    for i, s in ipairs(squids) do
      s:Update(dt)
    end
    
    for i, p in ipairs(pigs) do
      p:Update(dt)
    end
    
    for i, p in ipairs(projectiles) do
      p:update(dt)
    end
    
  end
  
  textUpdate(dt)
  swordUpdate(dt)
  hyroolMap:update(dt)
  flux.update(dt)
  heartsUpdate()
  squidSprites.up:update(dt)
  squidSprites.down:update(dt)
  squidSprites.left:update(dt)
  squidSprites.right:update(dt)
  pigSprites.up:update(dt)
  pigSprites.down:update(dt)
  pigSprites.left:update(dt)
  pigSprites.right:update(dt)
  itemSprites.heart:update(dt)
  
  for i, e in ipairs(explosions) do
    e.timer = e.timer - dt
    if e.timer <= 0 then
      table.remove(explosions, i)
    end
  end
  
  for i, n in ipairs(npcs) do
    n:Update(dt)
  end
end


function love.draw()
  love.graphics.translate(camera.X, camera.Y)
  hyroolMap:drawLayer(hyroolMap.layers['Tile Layer 1'])
  
  for i, p in ipairs(projectiles) do
    p:draw()
  end
  
  for i, s in ipairs(squids) do
    s:draw()
  end
  
  for i, p in ipairs(pigs) do
    p:draw()
  end
  
  for i, e in ipairs(explosions) do
    love.graphics.draw(misc_spriteSheet, explosion_quad, e.X, e.Y, 0, 6, 6)
  end
  
  for i, h in ipairs(hearts) do
    h:draw()
  end
  
  for i, n in ipairs(npcs) do
    n:Draw()
  end
  
  if loink.usingSword then
    loink.swordSprite:draw(loink_spriteSheet, loink.X, loink.Y, 0, 6, 6, 7.5, 7.5)
  elseif UsingShield() then
    love.graphics.draw(loink_spriteSheet, loinkShield_quad, loink.X, loink.Y, 0, 6, 6, 7.5, 7.5)
  else
    loink.sprite:draw(loink_spriteSheet, loink.X, loink.Y, 0, 6, 6, 7.5, 7.5)
  end
  
  heartsDraw()
  textDraw()
  
end


function love.keypressed(key, scancode, isrepeat)
  if key == 'space' then
    nextSentence()
  end
  
end


function distance(x1,y1,x2,y2)
  return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
