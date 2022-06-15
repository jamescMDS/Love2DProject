menuScene = {}

function menuScene.Construct()
  print("Menu::Construct")

  defaultDisplay = true
  mouseLock = false
  playBtnImg = love.graphics.newImage("button_play.png")
  playBtnImgDim = {playBtnImg:getDimensions()}

  exitBtnImg = love.graphics.newImage("button_quit.png")
  exitBtnImgDim = {exitBtnImg:getDimensions()}

  startBtnImg = love.graphics.newImage("button_start.png")
  startBtnImgDim = {startBtnImg:getDimensions()}

  centerX = love.graphics.getWidth()/2
  centerY = love.graphics.getHeight()/2
end

function menuScene.Update(dt)
  -- body...

  if defaultDisplay == true then

  -- default defaultDisplay
    menuScene.QuitClick()
    menuScene.PlayClick()

  else
    -- character selection display
    menuScene.StartClick()
  end

  if love.mouse.isDown(1) == false then
    mouseLock = false
  end

end

function menuScene.Draw()
  -- body...

  if defaultDisplay == true then

  -- default defaultDisplay
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(playBtnImg, centerX - playBtnImgDim[1] / 2, centerY - playBtnImgDim[2], 0, 1, 1)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(exitBtnImg, centerX - exitBtnImgDim[1] / 2, centerY + exitBtnImgDim[2], 0, 1, 1)

  else
    -- character selection display
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(startBtnImg, centerX - startBtnImgDim[1] / 2, centerY - startBtnImgDim[2] * 3, 0, 1, 1)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 1200 * 0.25 - 100, centerY + 20, 200, 200)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 1200 * 0.5 - 100, centerY + 20, 200, 200)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 1200 * 0.75 - 100, centerY + 20, 200, 200)
  end

end

function menuScene.PlayClick()
  if love.mouse.isDown(1) and mouseLock == false then
    if love.mouse.getX() > centerX - playBtnImgDim[1] / 2 and love.mouse.getX() < centerX - playBtnImgDim[1] / 2 + playBtnImgDim[1] then
      if love.mouse.getY() > centerY - playBtnImgDim[2] and love.mouse.getY() < centerY - playBtnImgDim[2] + playBtnImgDim[2] then
        mouseLock = true
        defaultDisplay = false
      end
    end
  end
end

function menuScene.QuitClick()
  if love.mouse.isDown(1) and mouseLock == false then
    if love.mouse.getX() > centerX - exitBtnImgDim[1] / 2 and love.mouse.getX() < centerX - exitBtnImgDim[1] / 2 + exitBtnImgDim[1] then
      if love.mouse.getY() > centerY + exitBtnImgDim[2] and love.mouse.getY() < centerY + exitBtnImgDim[2] + exitBtnImgDim[2] then
        mouseLock = true
        love.event.quit()
      end
    end
  end
end

function menuScene.StartClick()
  if love.mouse.isDown(1) and mouseLock == false then
    if love.mouse.getX() > centerX - startBtnImgDim[1] / 2 and love.mouse.getX() < centerX - startBtnImgDim[1] / 2 + startBtnImgDim[1] then
      if love.mouse.getY() > centerY - startBtnImgDim[2] * 3 and love.mouse.getY() < centerY - startBtnImgDim[2] * 3 + startBtnImgDim[2] then
        mouseLock = true
        ChangeScene("GameScene")
      end
    end
  end
end

return menuScene
