player = {}
require "Projectile"

function player.Construct(x, y, playerData, world)

  print("Player::Construct")
  player.world = world
  player.playerData = playerData
  player.x = x
  player.y = y
  player.dir = 1
  player.scale = 1.5
  sheet = love.graphics.newImage('Pink_Monster/Pink_Monster_Idle.png')
  imageDimension = {sheet:getDimensions()}
  player.width = imageDimension[1] / 4
  player.height = imageDimension[2]

  player.ConstructPhysics()

  player.ConstructAnimations();

  player.canJump = true
  player.isJumping = false
  player.isGrounded = true
  player.isIdle = true
  player.canShoot = true
  player.isShooting = false
  player.isVolting = false

  player.projectiles = {}

  groundedRay = {
		x1 = player.x,
		y1 = player.y + player.height * player.scale / 2,
		x2 = player.x,
		y2 = player.y + player.height * player.scale / 2 + 10,
		hitList = {}
	}

end

function player.ConstructPhysics()

  player.body = love.physics.newBody(player.world, player.x, player.y, "dynamic")
  player.body:setLinearDamping(0.75)
  player.shape = love.physics.newRectangleShape((player.width * player.scale)/2, (player.height * player.scale)/2, ((player.width) * player.scale), ((player.height) * player.scale)) -- ORIGINALLY DIVIDED BY 2
  player.fixture = love.physics.newFixture(player.body, player.shape, 1)
  player.fixture:setUserData(player)
  player.fixture:setFriction(0)

end

function player.ConstructAnimations()

  player.IdlePlayer()
  player.RunPlayer()
  player.JumpPlayer()
  player.ShootPlayer()
  player.ShootRunPlayer()

end

function player.RunPlayer()
  runPlayer = {}
  runPlayer.sheet = love.graphics.newImage(player.playerData.runAnimationFile)
  runPlayer.imageDimension = {runPlayer.sheet:getDimensions()}

  runPlayer.grid = anim8.newGrid(player.width, player.height, runPlayer.imageDimension[1], runPlayer.imageDimension[2])
  runPlayer.gridAnimation = anim8.newAnimation(runPlayer.grid('1-6', 1), 0.1, player.OnLoopRun)
  player.runPlayer = runPlayer

end

function player.OnLoopRun(_anim, _loops)
  --print("RunLoop")
end

function player.OnLoopJump(_anim, _loops)
  --print("JumpLoop")
  _anim:pauseAtStart()
end

function player.OnLoopIdle(_anim, _loops)
  --print("IdleLoop")
end

function player.OnLoopShoot(_anim, _loops)
  --print("ShootLoop")
  _anim:pauseAtStart()
  player.isShooting = false
end

function player.OnLoopShootRun(_anim, _loops)
  --print("ShootRunLoop")
  _anim:pauseAtStart()
  player.isShooting = false
end

function player.IdlePlayer()
  idlePlayer = {}
  idlePlayer.sheet = love.graphics.newImage(player.playerData.idleAnimationFile)
  idlePlayer.imageDimension = {idlePlayer.sheet:getDimensions()}
  idlePlayer.grid = anim8.newGrid(player.width, player.height, idlePlayer.imageDimension[1], idlePlayer.imageDimension[2])
  idlePlayer.gridAnimation = anim8.newAnimation(idlePlayer.grid('1-4', 1), 0.1, player.OnLoopIdle)
  player.idlePlayer = idlePlayer

end

function player.JumpPlayer()
  jumpPlayer = {}
  jumpPlayer.sheet = love.graphics.newImage(player.playerData.jumpAnimationFile)
  jumpPlayer.imageDimension = {jumpPlayer.sheet:getDimensions()}
  jumpPlayer.grid = anim8.newGrid(player.width, player.height, jumpPlayer.imageDimension[1], jumpPlayer.imageDimension[2])
  jumpPlayer.gridAnimation = anim8.newAnimation(jumpPlayer.grid('1-8', 1), 0.1, player.OnLoopJump)
  player.jumpPlayer = jumpPlayer

end

function player.ShootPlayer()
  shootPlayer = {}
  shootPlayer.sheet = love.graphics.newImage(player.playerData.attackAnimationFile)
  shootPlayer.imageDimension = {shootPlayer.sheet:getDimensions()}
  shootPlayer.grid = anim8.newGrid(player.width, player.height, shootPlayer.imageDimension[1], shootPlayer.imageDimension[2])
  shootPlayer.gridAnimation = anim8.newAnimation(shootPlayer.grid('1-4', 1), 0.1, player.OnLoopShoot)
  player.shootPlayer = shootPlayer

end

function player.ShootRunPlayer()
  shootRunPlayer = {}
  shootRunPlayer.sheet = love.graphics.newImage(player.playerData.runAttackAnimationFile)
  shootRunPlayer.imageDimension = {shootRunPlayer.sheet:getDimensions()}
  shootRunPlayer.grid = anim8.newGrid(player.width, player.height, shootRunPlayer.imageDimension[1], shootRunPlayer.imageDimension[2])
  shootRunPlayer.gridAnimation = anim8.newAnimation(shootRunPlayer.grid('1-6', 1), 0.1, player.OnLoopShootRun)
  player.shootRunPlayer = shootRunPlayer

end

function player.Update(dt)
  --player.body.setAngle(player.body, 0)
  player.body:setAngle(0)
  print(player.body:getLinearVelocity())
  local axisX = 0

  if love.keyboard.isDown('a') then
    axisX = axisX - 1
  end
  if love.keyboard.isDown('d') then
    axisX = axisX + 1
  end

  if axisX ~= 0 then
    if player.dir ~= axisX then
      player.runPlayer.gridAnimation:flipH()
      player.idlePlayer.gridAnimation:flipH()
      player.jumpPlayer.gridAnimation:flipH()
      player.shootPlayer.gridAnimation:flipH()
    end
    player.dir = axisX
  end

  if love.keyboard.isDown('space') and player.isVolting == false and player.isIdle == false then
    player.body:applyLinearImpulse(9000 * player.dir * dt, 0)
    player.isVolting = true
  end

  if player.isVolting == true then

    local vx, vy = player.body:getLinearVelocity()
    print("VELX = ", vx)
    if vx < 0 then vx = -vx end
    if vx < 200 then
      player.isVolting = false
      print("ISVOLTING=FALSE")
    end
  end
  if player.isGrounded then
    if player.isVolting == true then
      local vx, vy = player.body:getLinearVelocity()
      player.body:setLinearVelocity(vx + (0 - vx) * 0.4 * player.scale * dt, vy)
    else if axisX == 0 then
      local vx, vy = player.body:getLinearVelocity()
      player.body:setLinearVelocity(vx + (0 - vx) * 50 * player.scale * dt, vy)
      player.isIdle = true
    end
    end
  end

  if axisX ~= 0 and player.isVolting == false then
    vx, vy = player.body:getLinearVelocity()
    if vx < 350 and vx > -350 then
      if player.isGrounded then
        player.body:applyForce(axisX * 20000 * player.scale * dt, 0)
      else
        player.body:applyForce(axisX * 20000 * player.scale * dt * 0.1, 0)
      end
    end
    player.isIdle = false
  end

  if love.keyboard.isDown('w') and player.isVolting == false then
    if player.canJump == true then
      if player.isJumping == false and player.isGrounded == true then
        player.isJumping = true
        player.body:applyLinearImpulse(0, -10000 * player.scale * dt)
        player.jumpPlayer.gridAnimation:resume()
      else if(player.isJumping == false) then
        player.isJumping = true
        player.canJump = false
        player.body:applyLinearImpulse(0, -7000 * player.scale * dt)
      end
      end
    end
  else
    player.isJumping = false
  end

  player.GroundCheck()

end

function player.CutVelocity(x, y)

end
function player.Shoot()
  if love.keyboard.isDown('lctrl') then
    if player.isShooting == false and player.isGrounded == true then
      player.isShooting = true
      if player.isIdle == true then
        player.shootPlayer.gridAnimation:resume()
        local newProjectile = {}
        setmetatable(newProjectile, {__index = projectile})
        newProjectile.Construct(newProjectile, player.body:getX() + player.width * player.scale * player.dir, player.body:getY(), player.dir, 0, player.world)
        --table.insert(player.projectiles, newProjectile)
        table.insert(player.projectiles, 1, newProjectile)
      end
      if player.isIdle == false then
        player.shootRunPlayer.gridAnimation:resume()
        local newProjectile = {}
        setmetatable(newProjectile, {__index = projectile})
        newProjectile.Construct(newProjectile, player.body:getX() + player.width * player.scale, player.body:getY(), 1, 0, player.world)
        --table.insert(player.projectiles, newProjectile)
        table.insert(player.projectiles, 1, newProjectile)
      end
    end
  end

  for i = 1, table.getn(player.projectiles), 1 do
    if player.projectiles[i] ~= nil then
      if player.projectiles[i].isDestroyed == true then
        player.projectiles[i] = nil
      else
        player.projectiles[i].Update(player.projectiles[i], dt)
        player.projectiles[i].id = i
      end

    end

  end
end

function player.UpdateAnimations(dt)
  player.idlePlayer.gridAnimation:update(dt)
  player.runPlayer.gridAnimation:update(dt)
  player.jumpPlayer.gridAnimation:update(dt)
  player.shootPlayer.gridAnimation:update(dt)
  player.shootRunPlayer.gridAnimation:update(dt)
end

function player.GroundCheck()
  groundedRay.hitList = {}

  groundedRay.x1 = player.x + player.width * player.scale / 2
  groundedRay.y1 = player.y + (player.height) * player.scale - 1
  groundedRay.x2 = player.x + player.width * player.scale / 2
  groundedRay.y2 = player.y + (player.height) * player.scale + 10

  player.world:rayCast(groundedRay.x1, groundedRay.y1, groundedRay.x2, groundedRay.y2, worldRayCastCallback)

  groundedRay.x1 = player.x
  groundedRay.y1 = player.y + (player.height) * player.scale - 1
  groundedRay.x2 = player.x
  groundedRay.y2 = player.y + (player.height) * player.scale + 10

  player.world:rayCast(groundedRay.x1, groundedRay.y1, groundedRay.x2, groundedRay.y2, worldRayCastCallback)

  groundedRay.x1 = player.x + player.width * player.scale
  groundedRay.y1 = player.y + (player.height) * player.scale - 1
  groundedRay.x2 = player.x + player.width * player.scale
  groundedRay.y2 = player.y + (player.height) * player.scale + 10

  player.world:rayCast(groundedRay.x1, groundedRay.y1, groundedRay.x2, groundedRay.y2, worldRayCastCallback)

  if table.getn(groundedRay.hitList) > 0 then
    player.isGrounded = true
    player.canJump = true
  else
    player.isGrounded = false
  end
end

function player.Draw()
  love.graphics.rectangle("line", player.body:getX(), player.body:getY(), player.width * player.scale, player.height * player.scale)

  local xOffset = 0
  local vx, vy = player.body:getLinearVelocity()
  local scaleVal = 1
  if vx < -1 then
    scaleVal = -1
    --xOffset = (player.width - player.width / 2) * player.scale
    xOffset = (player.width) * player.scale
  end

  if player.isIdle == true and player.isGrounded == true and player.isShooting == false then
    player.idlePlayer.gridAnimation:draw(player.idlePlayer.sheet, player.x, player.y, 0, player.scale, player.scale, 0, 0)
  else if player.isGrounded == true and player.isShooting == false then
    player.runPlayer.gridAnimation:draw(player.runPlayer.sheet, player.x, player.y, 0, player.scale, player.scale, 0, 0)
  end
  end

  if player.isGrounded == false then
    player.jumpPlayer.gridAnimation:draw(player.jumpPlayer.sheet, player.x + xOffset, player.y, 0, player.scale * scaleVal, player.scale, 0, 0)
  end

  if player.isShooting == true and player.isIdle == true then
    player.shootPlayer.gridAnimation:draw(player.shootPlayer.sheet, player.x + xOffset, player.y, 0, player.scale * scaleVal, player.scale, 0, 0)
  end
  if player.isShooting == true and player.isIdle == false then
    player.shootRunPlayer.gridAnimation:draw(player.shootRunPlayer.sheet, player.x + xOffset, player.y, 0, player.scale * scaleVal, player.scale, 0, 0)
  end

  for i = 1, table.getn(player.projectiles), 1 do
    if player.projectiles[i] ~= nil then
      player.projectiles[i].Draw(player.projectiles[i])
    end

  end
end

function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
	local hit = {}
	hit.fixture = fixture
	hit.x, hit.y = x, y
	hit.xn, hit.yn = xn, yn
	hit.fraction = fraction
	table.insert(groundedRay.hitList, hit)
	return 1 -- Continues with ray cast through all shapes.
end

function player.OnCollisionBegin(a, b)

end

function player.TakeDamage(self, damage)

end

return player
