gameScene2 = {}
require "Player"
require "Enemy"
require "Wraith1_AnimData"
anim8 = require("anim8-master/anim8")
cameraFile = require("hump-master/camera")
require "particleSystem"

function gameScene2.Construct(selectedPlayer)
  love.physics.setMeter(64)
  love.graphics.setDefaultFilter("nearest", "nearest")
  gameScene2.selectedPlayer = selectedPlayer
  print(selectedPlayer.runAnimationFile)
  gameScene2.world = love.physics.newWorld(0, 10 * 64, false)

  gameScene2.world:setCallbacks( beginContact, endContact, preSolve, postSolve )

  gameScene2.enemies = {}
  centerX = love.graphics.getWidth()/2
  centerY = love.graphics.getHeight()/2

  player.Construct(700, centerY - 100, gameScene2.selectedPlayer, gameScene2.world)

  enemy1 = {}
  setmetatable(enemy1, {__index = enemy})
  enemy1.Construct(enemy1, 1500, centerY, 1300, centerY, 1600, centerY, wraith1AnimData, gameScene2.world)

  table.insert(gameScene2.enemies, enemy1)

  enemy2 = {}
  setmetatable(enemy2, {__index = enemy})
  enemy2.Construct(enemy2, 2300, 450, 2050, 450, 2600, 450, wraith1AnimData, gameScene2.world)

  table.insert(gameScene2.enemies, enemy2)

  enemy3 = {}
  setmetatable(enemy3, {__index = enemy})
  enemy3.Construct(enemy3, 4800, 375, 4500, 450, 5100, 450, wraith1AnimData, gameScene2.world)

  table.insert(gameScene2.enemies, enemy3)

  enemy4 = {}
  setmetatable(enemy4, {__index = enemy})
  enemy4.Construct(enemy4, 6000, 375, 5750, 450, 6200, 450, wraith1AnimData, gameScene2.world)

  table.insert(gameScene2.enemies, enemy4)

  enemy5 = {}
  setmetatable(enemy5, {__index = enemy})
  enemy5.Construct(enemy5, 9700, 100, 9400, 100, 9900, 100, wraith1AnimData, gameScene2.world)

  table.insert(gameScene2.enemies, enemy5)

  --enemy2 = {}
  --setmetatable(enemy2, {__index = enemy})
  --enemy2.Construct(enemy2, 3850, centerY + 120, 3250, centerY + 120, 3900, centerY + 120)
  --enemy2.IdlePlayer(enemy2, '2 Owlet_Monster/Owlet_Monster_Idle_4.png')
  --enemy2.RunPlayer(enemy2, '2 Owlet_Monster/Owlet_Monster_Run_6.png')
  --enemy2.JumpPlayer(enemy2,'2 Owlet_Monster/Owlet_Monster_Jump_8.png')
  --enemy2.ShootPlayer(enemy2, '2 Owlet_Monster/Owlet_Monster_Attack1_4.png')
  --enemy2.ShootRunPlayer(enemy2, '2 Owlet_Monster/Owlet_Monster_Walk+Attack_6.png')
  --enemy2.DiePlayer(enemy2, '2 Owlet_Monster/Owlet_Monster_Death_8.png')
  --table.insert(gameScene.enemies, enemy2)


  sti = require("Simple-Tiled-Implementation-master/sti")
  --map = sti("map3.lua")
  map = sti("mapfiles2.lua")

  border = love.graphics.newImage("fadegrad.png")
  platforms = {}

  gameScene2.AddPhysicsToLevel()

  cam = cameraFile()

  newPS = {}
  setmetatable(newPS, {__index = particleSystem})

  newPS.Construct(newPS, "BlueParticle.png", 1000, -1, 10, 12, 50)
end

function gameScene2.Destruct()
  gameScene2.world:destroy()
end

function beginContact(a, b, coll)

  if a:getUserData().OnCollisionBegin ~=nil then a:getUserData().OnCollisionBegin(a, b) end
  if b:getUserData().OnCollisionBegin ~=nil then b:getUserData().OnCollisionBegin(b, a) end

end

function gameScene2.Update(dt)
  -- body...

  if player.body:getY() > 640 then ChangeScene("Menu") return end
  gameScene2.world:update(dt)

  player.x = player.body:getX()
  player.y = player.body:getY()

  newPS.system:update(dt)

  player.Update(dt)

  for i = 1, table.getn(gameScene2.enemies), 1 do
    if gameScene2.enemies[i] ~= nil then
      gameScene2.enemies[i].Update(gameScene2.enemies[i], dt)
      if gameScene2.enemies[i].destroy == true then
        gameScene2.enemies[i] = nil
      end
    end

  end

  map:update(dt)

  --cam:lookAt(player.body:getX() + 300, player.body:getY() - 100)
  cam:lookAt(player.body:getX() + 300, centerY)
  --cam:lookAt(11580, 250)

  psPosX, psPosY = newPS.system:getPosition()

  if player.body:getX() > 11540 then
    ChangeScene("Menu")
  end
end

function gameScene2.Draw()
  -- body...
  --love.graphics.setDefaultFilter("nearest", "nearest")
  cam:attach()
  map:drawLayer(map.layers["Tile Layer 15"])
  map:drawLayer(map.layers["Tile Layer 14"])
  map:drawLayer(map.layers["Tile Layer 13"])
  map:drawLayer(map.layers["Tile Layer 12"])
  map:drawLayer(map.layers["Tile Layer 11"])
  map:drawLayer(map.layers["Tile Layer 10"])
  map:drawLayer(map.layers["Tile Layer 9"])
  map:drawLayer(map.layers["Tile Layer 8"])
  map:drawLayer(map.layers["Tile Layer 7"])
  map:drawLayer(map.layers["Tile Layer 6"])
  map:drawLayer(map.layers["Tile Layer 5"])


  player.Draw()
  for i = 1, table.getn(gameScene2.enemies), 1 do
    if gameScene2.enemies[i] ~= nil then
      gameScene2.enemies[i].Draw(gameScene2.enemies[i])
    end
  end

  love.graphics.draw(newPS.system, 11580, 285, 0, 0.05, 0.05, 250 * 0.05, 0)

  map:drawLayer(map.layers["Tile Layer 4"])
  map:drawLayer(map.layers["Tile Layer 3"])
  map:drawLayer(map.layers["Tile Layer 2"])
  map:drawLayer(map.layers["Tile Layer 1"])

  --love.graphics.push()
  --love.graphics.scale(1, 1.065)
  love.graphics.draw(border,0, 0, 0, 1, 1)
  --love.graphics.pop() -- so the scale doesn't affect anything else

  --love.graphics.setColor(255, 255, 255, 255)
  cam:detach()

end

function gameScene2.AddPhysicsToLevel()
  for i, obj in pairs(map.layers["Objects"].objects) do
    gameScene2.CreatePhysicsBodyAt(obj.x, obj.y, obj.width, obj.height)
  end
end

function gameScene2.CreatePhysicsBodyAt(xPosition, yPosition, width, height)
  platform = {}
  platform.width = width
  platform.height = height
  platform.body = love.physics.newBody(gameScene2.world, xPosition, yPosition, "static")
  platform.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
  platform.fixture = love.physics.newFixture(platform.body, platform.shape, 1)
  platform.fixture:setFriction(1)
  platform.fixture:setUserData(gameScene2)
  table.insert(platforms, platform)
end

return gameScene2
