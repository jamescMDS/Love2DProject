credits = {}

function credits.Construct()
  print("Credits::Construct")

  love.graphics.setDefaultFilter("nearest", "nearest")

  centerX = love.graphics.getWidth()/2
  centerY = love.graphics.getHeight()/2

  sti = require("Simple-Tiled-Implementation-master/sti")
  map = sti("MenuMap.lua")

  font = love.graphics.newFont('ChrustyRock-ORLA.ttf', 40)
  love.graphics.setFont(font)
  creditsTitle = love.graphics.newText(love.graphics.getFont(), "Credits")

  developer = love.graphics.newText(love.graphics.getFont(), "Developer")
  james = love.graphics.newText(love.graphics.getFont(), "James Charnley")

  artists = love.graphics.newText(love.graphics.getFont(), "Artists")
  maaot = love.graphics.newText(love.graphics.getFont(), "Maaot")
  craftpix = love.graphics.newText(love.graphics.getFont(), "CraftPix")
  proj = love.graphics.newText(love.graphics.getFont(), "XYEzawr")

  audio = love.graphics.newText(love.graphics.getFont(), "Audio")
  Mativve = love.graphics.newText(love.graphics.getFont(), "Mativve")
  SSS_Samples = love.graphics.newText(love.graphics.getFont(), "SSS_Samples")
  ejfortin = love.graphics.newText(love.graphics.getFont(), "ejfortin")
  Bertsz = love.graphics.newText(love.graphics.getFont(), "Bertsz")
  AaronGNP = love.graphics.newText(love.graphics.getFont(), "AaronGNP")
  Robinhood76 = love.graphics.newText(love.graphics.getFont(), "Robinhood76")
  laurenmg95 = love.graphics.newText(love.graphics.getFont(), "Laurenmg95")
  Lefty_Studios = love.graphics.newText(love.graphics.getFont(), "Lefty_Studios")
  jalastram = love.graphics.newText(love.graphics.getFont(), "jalastram")
  Zixem = love.graphics.newText(love.graphics.getFont(), "Zixem")
  EminYILDIRIM = love.graphics.newText(love.graphics.getFont(), "EminYILDIRIM")

  bluePlayerBGimage = love.graphics.newImage("3 Dude_Monster/bluerez.png")
  scrollOffset = 0

  music = love.audio.newSource("menumusic.wav", "static")
  music:setLooping(true)
  music:setVolume(0.8)
  music:play()
end
function credits.Destruct()
end
function credits.Update(dt)
  -- body...
  map:update(dt)

  scrollOffset = scrollOffset + dt * 40

  print(scrollOffset)

  if scrollOffset > 1669 then
    music:stop()
    ChangeScene("Menu")
  end
end

function credits.Draw()
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

  love.graphics.draw(creditsTitle, centerX - creditsTitle:getWidth() / 2, centerY - scrollOffset, 0, 1, 1)

  love.graphics.draw(developer, centerX - developer:getWidth() / 2, centerY + 150 - scrollOffset, 0, 1, 1)
  love.graphics.draw(james, centerX - james:getWidth() / 2, centerY + 200 - scrollOffset, 0, 1, 1)

  love.graphics.draw(artists, centerX - artists:getWidth() / 2, centerY + 350 - scrollOffset, 0, 1, 1)
  love.graphics.draw(maaot, centerX - maaot:getWidth() / 2, centerY + 400 - scrollOffset, 0, 1, 1)
  love.graphics.draw(craftpix, centerX - craftpix:getWidth() / 2, centerY + 450 - scrollOffset, 0, 1, 1)
  love.graphics.draw(proj, centerX - proj:getWidth() / 2, centerY + 500 - scrollOffset, 0, 1, 1)
  love.graphics.draw(james, centerX - james:getWidth() / 2, centerY + 550 - scrollOffset, 0, 1, 1)

  love.graphics.draw(audio, centerX - audio:getWidth() / 2, centerY + 700 - scrollOffset, 0, 1, 1)
  love.graphics.draw(Mativve, centerX - Mativve:getWidth() / 2, centerY + 750 - scrollOffset, 0, 1, 1)
  love.graphics.draw(SSS_Samples, centerX - SSS_Samples:getWidth() / 2, centerY + 800 - scrollOffset, 0, 1, 1)
  love.graphics.draw(ejfortin, centerX - ejfortin:getWidth() / 2, centerY + 850 - scrollOffset, 0, 1, 1)
  love.graphics.draw(Bertsz, centerX - Bertsz:getWidth() / 2, centerY + 900 - scrollOffset, 0, 1, 1)
  love.graphics.draw(AaronGNP, centerX - AaronGNP:getWidth() / 2, centerY + 950 - scrollOffset, 0, 1, 1)
  love.graphics.draw(Robinhood76, centerX - Robinhood76:getWidth() / 2, centerY + 1000 - scrollOffset, 0, 1, 1)
  love.graphics.draw(laurenmg95, centerX - laurenmg95:getWidth() / 2, centerY + 1050 - scrollOffset, 0, 1, 1)
  love.graphics.draw(Lefty_Studios, centerX - Lefty_Studios:getWidth() / 2, centerY + 1100 - scrollOffset, 0, 1, 1)
  love.graphics.draw(jalastram, centerX - jalastram:getWidth() / 2, centerY + 1150 - scrollOffset, 0, 1, 1)
  love.graphics.draw(Zixem, centerX - Zixem:getWidth() / 2, centerY + 1200 - scrollOffset, 0, 1, 1)
  love.graphics.draw(EminYILDIRIM, centerX - EminYILDIRIM:getWidth() / 2, centerY + 1250 - scrollOffset, 0, 1, 1)

end

return credits
