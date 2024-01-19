hearts = {}

function newHeart(x, y)
  heart = {}
  heart.X = x
  heart.Y = y
  
  world:add(heart, heart.X, heart.Y, 90, 90)
  
  function heart:draw()
    itemSprites.heart:draw(misc_spriteSheet, self.X, self.Y, 0, 6, 6)
  end
  
  table.insert(hearts, heart)
end
