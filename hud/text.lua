local nextTexts = {}
local displayText = ""
local textBoxHeight = 300
local showTextBox = false
local timer = 0.03
local i = 0
local updating = false

function say(newString)
  
  table.insert(nextTexts, newString)
  
end


function textUpdate(dt)
  
  displayText = nextTexts[1] or ""
  
  if displayText ~= "" then
    showTextBox = true
  else
    showTextBox = false
  end
  
end

function nextSentence()
  if displayText ~= "" then
    table.remove(nextTexts, 1)
  end
  
end

function textFinished()
  if displayText == "" then
    return true
  end
  return false
end

function textDraw()
  
  if showTextBox then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', -camera.X, -camera.Y + love.graphics.getHeight() - textBoxHeight, love.graphics.getWidth(), love.graphics.getHeight() - textBoxHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', -camera.X, -camera.Y + love.graphics.getHeight() - textBoxHeight - 20, love.graphics.getWidth(), 20)
    love.graphics.printf(displayText, -camera.X + 50, -camera.Y + love.graphics.getHeight() - textBoxHeight + 20, love.graphics.getWidth() - 100)
  end
  
end
