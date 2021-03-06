player = {}
require "Projectile"

function player.Construct(x, y, playerData, world, sceneName)

  print("Player::Construct")
  player.scene = sceneName
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

  player.heart = love.graphics.newImage('heart.png')

  player.canJump = true
  player.isJumping = false
  player.isGrounded = true
  player.isIdle = true
  player.canShoot = true
  player.isShooting = false
  player.isVolting = false
  player.voltTime = 2
  player.voltTimer = 0
  player.isDead = false;
  player.lives = 3
  player.isTakingDamage = false
  player.projectiles = {}

  groundedRay = {
		x1 = player.x,
		y1 = player.y + player.height * player.scale / 2,
		x2 = player.x,
		y2 = player.y + player.height * player.scale / 2 + 10,
		hitList = {}
	}

  player.jump1sfx = love.audio.newSource("jump1.wav", "static")
  player.jump1sfx:setLooping(false)
  player.jump1sfx:setVolume(0.8)
  player.jump2sfx = love.audio.newSource("jump2.wav", "static")
  player.jump2sfx:setLooping(false)
  player.jump2sfx:setVolume(0.8)
  player.landsfx = love.audio.newSource("land.wav", "static")
  player.landsfx:setLooping(false)
  player.landsfx:setVolume(1)
  player.voltsfx = love.audio.newSource("volt.wav", "static")
  player.voltsfx:setLooping(false)
  player.voltsfx:setVolume(1)
  player.damagesfx = love.audio.newSource("damage1.wav", "static")
  player.damagesfx:setLooping(false)
  player.damagesfx:setVolume(0.7)

  player.deathsfx = love.audio.newSource("death2.wav", "static")
  player.deathsfx:setLooping(false)
  player.deathsfx:setVolume(0.7)
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
  player.DiePlayer()
  player.DamagePlayer()

end

function player.RunPlayer()
  runPlayer = {}
  runPlayer.sheet = love.graphics.newImage(player.playerData.runAnimationFile)
  runPlayer.imageDimension = {runPlayer.sheet:getDimensions()}

  runPlayer.grid = anim8.newGrid(player.width, player.height, runPlayer.imageDimension[1], runPlayer.imageDimension[2])
  runPlayer.gridAnimation = anim8.newAnimation(runPlayer.grid('1-6', 1), 0.1, player.OnLoopRun)
  player.runPlayer = runPlayer

end

function player.DamagePlayer()
  damagePlayer = {}
  damagePlayer.sheet = love.graphics.newImage(player.playerData.damageAnimationFile)
  damagePlayer.imageDimension = {damagePlayer.sheet:getDimensions()}

  damagePlayer.grid = anim8.newGrid(player.width, player.height, damagePlayer.imageDimension[1], damagePlayer.imageDimension[2])
  damagePlayer.gridAnimation = anim8.newAnimation(damagePlayer.grid('1-4', 1), 0.1, player.OnLoopDamage)
  player.damagePlayer = damagePlayer

end

function player.OnLoopRun(_anim, _loops)
  --print("RunLoop")
end

function player.OnLoopDamage(_anim, _loops)
  --print("RunLoop")
  player.isTakingDamage = false
  _anim:pauseAtStart()
end

function player.OnLoopDie(_anim, _loops)
  --print("RunLoop")
  _anim:pauseAtStart()
  if player.isDead == true then
    ChangeScene(player.scene)
  end
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
  _anim:pauseAtEnd()
  --player.isShooting = false
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

function player.DiePlayer()
  diePlayer = {}
  diePlayer.sheet = love.graphics.newImage(player.playerData.dieAnimationFile)
  diePlayer.imageDimension = {diePlayer.sheet:getDimensions()}
  diePlayer.grid = anim8.newGrid(player.width, player.height, diePlayer.imageDimension[1], diePlayer.imageDimension[2])
  diePlayer.gridAnimation = anim8.newAnimation(diePlayer.grid('1-3', 1), 0.1, player.OnLoopDie)
  player.diePlayer = diePlayer

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
  shootPlayer.gridAnimation = anim8.newAnimation(shootPlayer.grid('1-3', 1), 0.075, player.OnLoopShoot)
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
  --print(player.body:getLinearVelocity())
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
      player.diePlayer.gridAnimation:flipH()
      player.damagePlayer.gridAnimation:flipH()
    end
    player.dir = axisX
  end

  if love.keyboard.isDown('space') and player.isVolting == false and player.isIdle == false then
    player.body:applyLinearImpulse(12000 * player.dir * dt, 0)
    player.isVolting = true
    player.voltsfx:play()
    player.voltTimer = player.voltTime
    player.shootPlayer.gridAnimation:resume()
  end

  if player.isVolting == true then
    local vx, vy = player.body:getLinearVelocity()
    if vx < 0 and axisX > 0 then
      player.isVolting = false
      player.shootPlayer.gridAnimation:pauseAtStart()
      player.body:setLinearVelocity(0,0)
    end
    if vx > 0 and axisX < 0 then
      player.isVolting = false
      player.shootPlayer.gridAnimation:pauseAtStart()
      player.body:setLinearVelocity(0,0)
    end
    if player.voltTimer > 0 then
      player.voltTimer = player.voltTimer - dt
    else
      player.isVolting = false
      player.shootPlayer.gridAnimation:pauseAtStart()
      player.body:setLinearVelocity(0,0)
    end


    if vx < 0 then vx = -vx end
    if vx < 200 then
      player.isVolting = false
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
        player.jump1sfx:play()
        player.isJumping = true
        player.body:applyLinearImpulse(0, -10000 * player.scale * dt)
        player.jumpPlayer.gridAnimation:resume()
      else if(player.isJumping == false) then
        player.jump2sfx:play()
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
  player.UpdateAnimations(dt)
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
  player.diePlayer.gridAnimation:update(dt)
  player.damagePlayer.gridAnimation:update(dt)
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
    if player.isGrounded == false then
      player.landsfx:play()
    end
    player.isGrounded = true
    player.canJump = true
  else
    player.isGrounded = false
  end
end

function player.Draw()
  --love.graphics.rectangle("line", player.body:getX(), player.body:getY(), player.width * player.scale, player.height * player.scale)

  if player.isDead == false then

    if player.isIdle == true and player.isGrounded == true and player.isShooting == false and player.isTakingDamage == false then
      player.idlePlayer.gridAnimation:draw(player.idlePlayer.sheet, player.x, player.y, 0, player.scale, player.scale, 0, 0)
    else if player.isGrounded == true and player.isVolting == false and player.isTakingDamage == false then
      player.runPlayer.gridAnimation:draw(player.runPlayer.sheet, player.x, player.y, 0, player.scale, player.scale, 0, 0)
    end
    end

    if player.isGrounded == false then
      player.jumpPlayer.gridAnimation:draw(player.jumpPlayer.sheet, player.x, player.y, 0, player.scale, player.scale, 0, 0)
    end

    if player.isVolting == true and player.isTakingDamage == false then
      player.shootPlayer.gridAnimation:draw(player.shootPlayer.sheet, player.x, player.y, 0, player.scale, player.scale, 0, 0)
    end

    if player.isTakingDamage == true then
      player.damagePlayer.gridAnimation:draw(player.damagePlayer.sheet, player.x, player.y, 0, player.scale, player.scale, 0, 0)
    end

    for i = 1, table.getn(player.projectiles), 1 do
      if player.projectiles[i] ~= nil then
        player.projectiles[i].Draw(player.projectiles[i])
      end

    end
  else
    player.diePlayer.gridAnimation:draw(player.diePlayer.sheet, player.x, player.y, 0, player.scale, player.scale, 0, 0)

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
  if a:getUserData().fixture == nil then
    return
  end
  if player.isVolting == true then
    if b:getUserData().TakeDamage ~=nil then
      b:getUserData().TakeDamage(b, 500)
      a:getUserData().body:setLinearVelocity(0, 0)
    end
  end

end

function player.TakeDamage(self, damage)
  player.lives = player.lives - 1
  player.damagePlayer.gridAnimation:resume()
  player.damagesfx:play()
  player.isTakingDamage = true
  if player.lives == 0 then
    player.isDead = true;
    player.diePlayer.gridAnimation:resume()
    player.deathsfx:play()
  end
end

return player
