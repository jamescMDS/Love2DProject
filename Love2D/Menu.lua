menuScene = {}

function menuScene.Construct()
  print("Menu::Construct")
  image = love.graphics.newImage("imagetest.png")

  centerX = love.graphics.getWidth()/2
  centerY = love.graphics.getHeight()/2
end

function menuScene.Update(dt)
  -- body...
  if love.mouse.isDown(1) then
    ChangeScene("GameScene")
  end

end

function menuScene.Draw()
  -- body...

  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.rectangle("fill", centerX, centerY - 150, 200, 50)

  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.circle("fill", centerX, centerY, 50)

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(image, 0, 0, 0, 0.5, 0.5)

end

return menuScene
