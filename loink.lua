
loink = {}

loink.X = hyroolMap.layers['loink starting point'].objects[1].x - 45
loink.Y = hyroolMap.layers['loink starting point'].objects[1].y - 45

world:add(loink, loink.X, loink.Y, 90, 90)

loink.sprite = loinkSprites.down
loink.swordSprite = loinkSprites.swordDown
loink.usingSword = false
loink.health = 6
loink.dir = 3
loink.hitTimer = 0

local speed = 420
local startTime = 0.2
local timer = 0
local healthTimer = 0
local shieldTimer = 0
local shieldCooldown = 0
local spacePressed = false
local v = {}
v.X = 0
v.Y = 0


function loinkUpdate(dt)
  loink.sprite:update(dt)
  loink.swordSprite:update(dt)
  loink.startedSword = false
  
  if love.mouse.isDown(1) and timer <= 0 and loink.startedSword == false then
    loink.usingSword = true
  end
  
  if timer > 0 then
    timer = timer - dt
  end
  
  if loink.hitTimer > 0 then
    loink.hitTimer = loink.hitTimer - dt
  end
  
  if healthTimer > 0 then
    healthTimer = healthTimer - dt
  end
  
  if shieldTimer > 0 then
    shieldTimer = shieldTimer - dt
  end
  
  if shieldCooldown > 0 then
    shieldCooldown = shieldCooldown - dt
  end
  
  if love.keyboard.isDown('w', 'a', 's', 'd') and not loink.usingSword and shieldTimer <= 0 then
    loink.sprite:resume()
    if love.keyboard.isDown('w') then
      loink.sprite = loinkSprites.up
      v.Y = -speed * dt
      loink.dir = 1
    elseif love.keyboard.isDown('d') then
      loink.sprite = loinkSprites.right
      v.X = speed * dt
      loink.dir = 2
    elseif love.keyboard.isDown('s') then
      loink.sprite = loinkSprites.down
      v.Y = speed * dt
      loink.dir = 3
    elseif love.keyboard.isDown('a') then
      loink.sprite = loinkSprites.left
      v.X = -speed * dt
      loink.dir = 4
    end
    
    if shieldCooldown <= 0 and love.mouse.isDown(2) then
      shieldTimer = 0.3
      shieldCooldown = 1
    end
  elseif not loink.usingSword then
    loink.swordSprite:pause()
    loink.swordSprite:gotoFrame(1)
    loink.sprite:pause()
    loink.sprite:gotoFrame(1)
    if shieldCooldown <= 0 and love.mouse.isDown(2) then
      shieldTimer = 0.3
      shieldCooldown = 1
    end
  else
    loink.swordSprite:resume()
    if loink.sprite == loinkSprites.up then
      loink.swordSprite = loinkSprites.swordUp
    elseif loink.sprite == loinkSprites.right then
      loink.swordSprite = loinkSprites.swordRight
    elseif loink.sprite == loinkSprites.down then
      loink.swordSprite = loinkSprites.swordDown
    elseif loink.sprite == loinkSprites.left then
      loink.swordSprite = loinkSprites.swordLeft
    end
    loink.sprite:update(dt)
    if loink.swordSprite.position == 4 then
      loink.usingSword = false
      speed = 420
      timer = startTime
    end
  end
  
  local goalX, goalY = loink.X + v.X, loink.Y + v.Y
  local actualX, actualY, cols, len = world:move(loink, goalX, goalY, function(item, other)
      for i, p in ipairs(projectiles) do
        if other == p then
          return 'cross'
        end
      end
      for i, n in ipairs(npcs) do
        if other == n.radius then
          return 'cross'
        end
      end
      return 'slide'
    end)
  loink.X, loink.Y = actualX, actualY
  
  for ci, col in ipairs(cols) do
    for si, squid in ipairs(squids) do
      if col.other == squid and healthTimer <= 0 then
        loink.health = loink.health - 1
        healthTimer = 1
      end
    end
    for pi, pig in ipairs(pigs) do
      if col.other == pig and healthTimer <= 0 then
        loink.health = loink.health - 1
        healthTimer = 1
      end
    end
    for pi, proj in ipairs(projectiles) do
      if col.other == proj and healthTimer <= 0 then
        if UsingShield() then
          proj:ReverseMovement()
        else
          loink.health = loink.health - 1
          healthTimer = 1
        end
      end
    end
    for hi, heart in ipairs(hearts) do
      if col.other == heart then
        loink.health = loink.health + 2
        world:remove(heart)
        table.remove(hearts, hi)
      end
    end
    for ni, npc in ipairs(npcs) do
      if col.other == npc.radius and love.keyboard.isDown('space') and not spacePressed then
        npc:startTalking()
        spacePressed = true
      end
    end
  end
  
  if textFinished() then
    gamestate = 'playing'
    spacePressed = false
  end
  
  v.X, v.Y = 0, 0
  if loink.health > 6 then
    loink.health = 6
  end
  
  if loink.health < 0 then
    loink.health = 0
  end
end

function UsingShield()
  if shieldTimer > 0 then
    return true
  else
    return false
  end
end
