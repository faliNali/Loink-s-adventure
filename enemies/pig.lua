
pigs = {}

function newPig(x, y)
  pig = {}
  pig.X = x
  pig.Y = y
  pig.sprite = pigSprites.down
  pig.spearQuad = spearUp_quad
  
  local health = 15
  local hit = false
  local speed = math.random(100, 150)
  local dir = 1
  local timer = math.random(2, 4)
  local hitTimer = 0
  local projTimer = math.random(2, 3)
  local v = {}
  v.X = 0
  v.Y = 0
  local goalX, goalY, actualX, actualY, cols, len

  world:add(pig, pig.X, pig.Y, 30, 30)
  
  function pig:Update(dt)
    timer = timer - dt
    hitTimer = hitTimer - dt
    projTimer = projTimer - dt
    
    if dir == 1 then
      v.Y = -speed * dt
      self.sprite = pigSprites.up
      self.spearQuad = spearUp_quad
    elseif dir == 2 then
      v.X = speed * dt
      self.sprite = pigSprites.right
      self.spearQuad = spearRight_quad
    elseif dir == 3 then
      v.Y = speed * dt
      self.sprite = pigSprites.down
      self.spearQuad = spearDown_quad
    else
      v.X = -speed * dt
      self.sprite = pigSprites.left
      self.spearQuad = spearLeft_quad
    end
    
    goalX, goalY = self.X + v.X, self.Y + v.Y
    actualX, actualY, cols, len = world:move(self, goalX, goalY, function(item, other)
      for i, p in ipairs(projectiles) do
        if other == p then
          return 'cross'
        end
      end
      return 'slide'
    end)
    self.X, self.Y = actualX, actualY
    
    v.X, v.Y = 0, 0
    

    if timer <= 0 or len > 0 then
      dir = math.random(1, 4)
      timer = math.random(1, 4)
    end
    
    if projTimer <= 0 and distance(loink.X, loink.Y, self.X, self.Y) < 600 then
      projTimer = math.random(1, 3)
      newProjectile(self.X + 5, self.Y + 5, dir, 640, self.spearQuad)
    end
    
    if hit then
      health = health - 1
      hit = false
    end
    
    if health <= 0 then
      math.randomseed(os.time())
      if math.random(0, 100) < 20 then
        newHeart(self.X - 30, self.Y - 30)
      end
      for i, s in ipairs(pigs) do
        if s == self then
          table.insert(explosions, {X = self.X - 30, Y = self.Y - 30, timer = explosionTimer})
          world:remove(self)
          table.remove(pigs, i)
        end

      end
      
    end
    
  end
  
  function pig:hit()
    hit = true
    hitTimer = 0.06
  end
  
  function pig:draw()
    if hitTimer > 0 then
      love.graphics.setColor(0.85, 0.5, 0.5)
    end
    
    self.sprite:draw(enemy_spriteSheet, self.X - 30, self.Y - 30, 0, 6, 6)
    
    love.graphics.setColor(1, 1, 1)
  end
  
  table.insert(pigs, pig)
  
end