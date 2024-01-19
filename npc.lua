npcs = {}

function newNPC(X, Y, sprite, firstQuad, secondQuad, dialogue)
  local npc = {}
  npc.radius = {}
  local currentQuad = firstQuad
  local radiusX = X - 90
  local radiusY = Y - 90
  local isTalking = false
  local spaceClicked = false
  world:add(npc, X, Y, 90, 90)
  world:add(npc.radius, radiusX, radiusY, 270, 270)
  
  function npc:Update(dt)
    if isTalking then
      for i, s in ipairs(dialogue) do
        say(s)
      end
      isTalking = false
    end
  end
  
  function npc:Draw()
    love.graphics.draw(sprite, currentQuad, X, Y, 0, 6, 6)
    love.graphics.rectangle('line', radiusX, radiusY, 270, 270)
  end
  
  function npc:startTalking()
    isTalking = true
    gamestate = 'talking'
  end
  
  table.insert(npcs, npc)
  return npc
end
