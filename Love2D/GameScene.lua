gameScene = {}
require "Player"
require "Enemy"
anim8 = require("anim8-master/anim8")
cameraFile = require("hump-master/camera")

function gameScene.Construct()
  love.physics.setMeter(64)
  gameScene.world = love.physics.newWorld(0, 10 * 64, false)

  gameScene.world:setCallbacks( beginContact, endContact, preSolve, postSolve )

  gameScene.enemies = {}
  centerX = love.graphics.getWidth()/2
  centerY = love.graphics.getHeight()/2

  player.Construct(450, centerY + 100)
  enemy1 = {}
  setmetatable(enemy1, {__index = enemy})
  enemy1.Construct(enemy1, 1300, centerY + 120, 1160, centerY + 120, 1480, centerY + 120)
  enemy1.IdlePlayer(enemy1, '3 Dude_Monster/Dude_Monster_Idle_4.png')
  enemy1.RunPlayer(enemy1, '3 Dude_Monster/Dude_Monster_Run_6.png')
  enemy1.JumpPlayer(enemy1,'3 Dude_Monster/Dude_Monster_Jump_8.png')
  enemy1.ShootPlayer(enemy1, '3 Dude_Monster/Dude_Monster_Attack1_4.png')
  enemy1.ShootRunPlayer(enemy1, '3 Dude_Monster/Dude_Monster_Walk+Attack_6.png')
  enemy1.DiePlayer(enemy1, '3 Dude_Monster/Dude_Monster_Death_8.png')
  table.insert(gameScene.enemies, enemy1)

  enemy2 = {}
  setmetatable(enemy2, {__index = enemy})
  enemy2.Construct(enemy2, 3850, centerY + 120, 3250, centerY + 120, 3900, centerY + 120)
  enemy2.IdlePlayer(enemy2, '2 Owlet_Monster/Owlet_Monster_Idle_4.png')
  enemy2.RunPlayer(enemy2, '2 Owlet_Monster/Owlet_Monster_Run_6.png')
  enemy2.JumpPlayer(enemy2,'2 Owlet_Monster/Owlet_Monster_Jump_8.png')
  enemy2.ShootPlayer(enemy2, '2 Owlet_Monster/Owlet_Monster_Attack1_4.png')
  enemy2.ShootRunPlayer(enemy2, '2 Owlet_Monster/Owlet_Monster_Walk+Attack_6.png')
  enemy2.DiePlayer(enemy2, '2 Owlet_Monster/Owlet_Monster_Death_8.png')
  table.insert(gameScene.enemies, enemy2)


  sti = require("Simple-Tiled-Implementation-master/sti")
  map = sti("map3.lua")

  border = love.graphics.newImage("border2.png")
  platforms = {}

  gameScene.AddPhysicsToLevel()

  cam = cameraFile()
end

function beginContact(a, b, coll)

  if a:getUserData().OnCollisionBegin ~=nil then a:getUserData().OnCollisionBegin(a, b) end
  if b:getUserData().OnCollisionBegin ~=nil then b:getUserData().OnCollisionBegin(b, a) end

end

function gameScene.Update(dt)
  -- body...
  gameScene.world:update(dt)

  player.x = player.body:getX()
  player.y = player.body:getY()



  player.Update(dt)

  for i = 1, table.getn(gameScene.enemies), 1 do
    if gameScene.enemies[i] ~= nil then
      gameScene.enemies[i].Update(gameScene.enemies[i], dt)
      if gameScene.enemies[i].destroy == true then
        gameScene.enemies[i] = nil 
      end
    end

  end

  map:update(dt)

  --cam:lookAt(player.body:getX() + 300, player.body:getY() - 100)
  cam:lookAt(player.body:getX() + 300, centerY + 360)
  --cam:lookAt(3600, centerY + 360)

end

function gameScene.Draw()
  -- body...

  cam:attach()
  map:drawLayer(map.layers["Tile Layer 8"])
  map:drawLayer(map.layers["Tile Layer 7"])
  map:drawLayer(map.layers["Tile Layer 6"])
  map:drawLayer(map.layers["Tile Layer 5"])
  map:drawLayer(map.layers["Tile Layer 4"])
  map:drawLayer(map.layers["Tile Layer 3"])
  map:drawLayer(map.layers["Tile Layer 2"])

  player.Draw()
  for i = 1, table.getn(gameScene.enemies), 1 do
    if gameScene.enemies[i] ~= nil then
      gameScene.enemies[i].Draw(gameScene.enemies[i])
    end
  end


  map:drawLayer(map.layers["Tile Layer 1"])
  map:drawLayer(map.layers["Tile Layer 10"])
  map:drawLayer(map.layers["Tile Layer 9"])

  love.graphics.push()
  love.graphics.scale(1, 1.065)
  love.graphics.draw(border, 0 / 1, 361.25 / 1.065)
  love.graphics.pop() -- so the scale doesn't affect anything else

  --love.graphics.setColor(255, 255, 255, 255)
  cam:detach()

end

function gameScene.AddPhysicsToLevel()
  for i, obj in pairs(map.layers["Objects"].objects) do
    gameScene.CreatePhysicsBodyAt(obj.x, obj.y, obj.width, obj.height)
  end
end

function gameScene.CreatePhysicsBodyAt(xPosition, yPosition, width, height)
  platform = {}
  platform.width = width
  platform.height = height
  platform.body = love.physics.newBody(gameScene.world, xPosition, yPosition, "static")
  platform.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
  platform.fixture = love.physics.newFixture(platform.body, platform.shape, 1)
  platform.fixture:setFriction(1)
  platform.fixture:setUserData(gameScene)
  table.insert(platforms, platform)
end

return gameScene
