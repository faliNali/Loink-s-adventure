projectiles = {}

function newProjectile(X, Y, dir, speed, quad)
  proj = {}
  proj.X = X
  proj.Y = Y
  proj.dir = dir
  proj.speed = speed
  proj.quad = quad
  
  local v = {}
  v.X = 0
  v.Y = 0
  local timer = 3
  local reverse = false
  
  world:add(proj, proj.X, proj.Y, 20, 20)
  
  function proj:update(dt)
    tiemer = timer - dt
    if self.dir == 1 then
      v.Y = -self.speed * dt
    elseif self.dir == 2 then
      v.X = self.speed * dt
    elseif self.dir == 3 then
      v.Y = self.speed * dt
    else
      v.X = -self.speed * dt
    end
    
    local goalX, goalY
    if reverse then
      goalX, goalY = self.X + -v.X, self.Y + -v.Y
    else
      goalX, goalY = self.X + v.X, self.Y + v.Y
    end
    
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, function(item, other) return 'cross' end)
    self.X, self.Y = actualX, actualY
    
    v.X, v.Y = 0, 0
    
    if timer <= 0 then
      for i, p in ipairs(projectiles) do
        if p == self then
          world:remove(self)
          table.remove(projectiles, i)
        end
      end
    end
  end
  
  function proj:draw()
    love.graphics.draw(misc_spriteSheet, self.quad, self.X - 35, self.Y - 35, 0, 6, 6)
  end
  
  function proj:ReverseMovement()
    reverse = true
  end
  
  table.insert(projectiles, proj)
end
