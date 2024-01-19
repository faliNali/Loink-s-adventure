
function swordUpdate(dt)
  if loink.usingSword then
    local hitbox = {}
    
    if loink.dir == 1 then
      hitbox.X = loink.X - 45
      hitbox.Y = loink.Y - 90
      hitbox.width = 180
      hitbox.height = 90
    elseif loink.dir == 2 then
      hitbox.X = loink.X + 90
      hitbox.Y = loink.Y - 45
      hitbox.width = 90
      hitbox.height = 180
    elseif loink.dir == 3 then
      hitbox.X = loink.X - 45
      hitbox.Y = loink.Y + 90
      hitbox.width = 180
      hitbox.height = 90
    else
      hitbox.X = loink.X - 90
      hitbox.Y = loink.Y - 45
      hitbox.width = 90
      hitbox.height = 180
    end
    
    world:add(hitbox, hitbox.X, hitbox.Y, hitbox.width, hitbox.height)
    local actualX, actualY, cols, len = world:check(hitbox, hitbox.X, hitbox.Y)
    for ci, col in ipairs(cols) do
      for si, squid in ipairs(squids) do
        if col.other == squid then
          squid:hit()
        end
      end
      for pi, pig in ipairs(pigs) do
        if col.other == pig then
          pig:hit()
        end
      end
    end
    world:remove(hitbox)
    
  end
  
end

