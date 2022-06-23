menuScene = {}
local pinkplayerdata = require "PinkPlayerData"
local blueplayerdata = require "BluePlayerData"
local whiteplayerdata = require "WhitePlayerData"
function menuScene.Construct()
  print("Menu::Construct")
  defaultDisplay = true
  mouseLock = false

  love.graphics.setDefaultFilter("nearest", "nearest")

  playBtnImg = love.graphics.newImage("button_play.png")
  playBtnImgDim = {playBtnImg:getDimensions()}

  exitBtnImg = love.graphics.newImage("button_quit.png")
  exitBtnImgDim = {exitBtnImg:getDimensions()}

  startBtnImg = love.graphics.newImage("button_start.png")
  startBtnImgDim = {startBtnImg:getDimensions()}

  centerX = love.graphics.getWidth()/2
  centerY = love.graphics.getHeight()/2

  pinkplayerdata.Construct()
  pinkPlayerImg = love.graphics.newImage("Pink_Monster/Pink_Monster.png")
  blueplayerdata.Construct()
  bluePlayerImg = love.graphics.newImage("3 Dude_Monster/Dude_Monster.png")
  whiteplayerdata.Construct()
  whitePlayerImg = love.graphics.newImage("2 Owlet_Monster/Owlet_Monster.png")

  selectedPlayerData = pinkplayerdata

  sti = require("Simple-Tiled-Implementation-master/sti")
  map = sti("MenuMap.lua")

  bluePlayerBGimage = love.graphics.newImage("3 Dude_Monster/bluerez.png")

  music = love.audio.newSource("menumusic.wav", "static")
  music:setLooping(true)
  music:setVolume(0.8)
  music:play()
end
function menuScene.Destruct()
end
function menuScene.Update(dt)
  -- body...
  map:update(dt)
  if defaultDisplay == true then

  -- default defaultDisplay
    menuScene.QuitClick()
    menuScene.PlayClick()

  else
    -- character selection display
    menuScene.StartClick()
    menuScene.CharacterBoxClick()
  end

  if love.mouse.isDown(1) == false then
    mouseLock = false
  end

end

function menuScene.Draw()
  -- body...

  map:drawLayer(map.layers["Tile Layer 9"])
  map:drawLayer(map.layers["Tile Layer 8"])
  map:drawLayer(map.layers["Tile Layer 7"])
  map:drawLayer(map.layers["Tile Layer 6"])
  map:drawLayer(map.layers["Tile Layer 5"])
  map:drawLayer(map.layers["Tile Layer 4"])
  map:drawLayer(map.layers["Tile Layer 3"])
  map:drawLayer(map.layers["Tile Layer 2"])
  love.graphics.draw(bluePlayerBGimage, centerX + 220, centerY - 155, 0, -1, 1)
  map:drawLayer(map.layers["Tile Layer 1"])


  --love.graphics.rectangle("fill", 0, 0, 1200, 640)
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

    if selectedPlayerData == pinkplayerdata then
      love.graphics.setColor(0, 0, 0, 0.8)
      love.graphics.rectangle("fill", 1200 * 0.25 - 100, centerY + 20, 200, 200)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(pinkPlayerImg, 1200 * 0.25 - 100, centerY + 20, 0, 6, 6)
    else
      love.graphics.setColor(0, 0, 0, 0.4)
      love.graphics.rectangle("fill", 1200 * 0.25 - 100, centerY + 20, 200, 200)
      love.graphics.setColor(1, 1, 1, 0.4)
      love.graphics.draw(pinkPlayerImg, 1200 * 0.25 - 100, centerY + 20, 0, 6, 6)
    end

    if selectedPlayerData == whiteplayerdata then
      love.graphics.setColor(0, 0, 0, 0.8)
      love.graphics.rectangle("fill", 1200 * 0.5 - 100, centerY + 20, 200, 200)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(whitePlayerImg, 1200 * 0.5 - 90, centerY + 20, 0, 6, 6)
    else
      love.graphics.setColor(0, 0, 0, 0.4)
      love.graphics.rectangle("fill", 1200 * 0.5 - 100, centerY + 20, 200, 200)
      love.graphics.setColor(1, 1, 1, 0.4)
      love.graphics.draw(whitePlayerImg, 1200 * 0.5 - 90, centerY + 20, 0, 6, 6)
    end


    if selectedPlayerData == blueplayerdata then
      love.graphics.setColor(0, 0, 0, 0.8)
      love.graphics.rectangle("fill", 1200 * 0.75 - 100, centerY + 20, 200, 200)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(bluePlayerImg, 1200 * 0.75 - 100, centerY + 20, 0, 6, 6)
    else
      love.graphics.setColor(0, 0, 0, 0.4)
      love.graphics.rectangle("fill", 1200 * 0.75 - 100, centerY + 20, 200, 200)
      love.graphics.setColor(1, 1, 1, 0.4)
      love.graphics.draw(bluePlayerImg, 1200 * 0.75 - 100, centerY + 20, 0, 6, 6)
    end


    love.graphics.setColor(1, 1, 1, 1)
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
        music:stop()
        ChangeScene("GameScene")
      end
    end
  end
end

function menuScene.CharacterBoxClick()
  --pink Player
  if love.mouse.isDown(1) and mouseLock == false then
    if love.mouse.getX() > 1200 * 0.25 - 100 and love.mouse.getX() < 1200 * 0.25 - 100 + 200 then
      if love.mouse.getY() > centerY + 20 and love.mouse.getY() < centerY + 20 + 200 then
        mouseLock = true
        selectedPlayerData = pinkplayerdata
      end
    end
  end

  --blue player
  if love.mouse.isDown(1) and mouseLock == false then
    if love.mouse.getX() > 1200 * 0.75 - 100 and love.mouse.getX() < 1200 * 0.75 - 100 + 200 then
      if love.mouse.getY() > centerY + 20 and love.mouse.getY() < centerY + 20 + 200 then
        mouseLock = true
        selectedPlayerData = blueplayerdata
      end
    end
  end

  --whitePlayer
  if love.mouse.isDown(1) and mouseLock == false then
    if love.mouse.getX() > 1200 * 0.5 - 100 and love.mouse.getX() < 1200 * 0.5 - 100 + 200 then
      if love.mouse.getY() > centerY + 20 and love.mouse.getY() < centerY + 20 + 200 then
        mouseLock = true
        selectedPlayerData = whiteplayerdata
      end
    end
  end

end

return menuScene
