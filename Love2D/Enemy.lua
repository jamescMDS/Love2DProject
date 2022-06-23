enemy = {}
require "Projectile"
function math.normalize(nx, ny)
  local l = (nx * nx + ny * ny) ^ .5
  if l == 0 then
    return 0,0,0
  else
    return nx / l, ny / l ,l
  end
end
-----------------------------------------------------
-------------------CONSTRUCT ENEMY-------------------
function enemy.Construct(self, x, y, wpx1, wpy1, wpx2, wpy2, animData, world)
  print("Enemy::Construct")
  self.world = world
  self.x = x
  self.y = y
  self.animData = animData
  self.animData.Construct()
  --enemy.selfRef = self


  self.speed = 80000

  self.shootInterval = 1.5
  self.shootIntervalTimer = 0;

  self.waypointX1 = wpx1
  self.waypointY1 = wpy1

  self.waypointX2 = wpx2
  self.waypointY2 = wpy2

  self.curWaypointX = self.waypointX1
  self.curWaypointY = self.waypointY1

  self.velx = self.curWaypointX - self.x
  self.vely = self.curWaypointY - self.y
  local nx = self.velx
  local ny = self.vely
  self.velx, self.vely = math.normalize(nx, ny)
  --self.velx = self.velx / self.velx
  --self.vely = self.vely / self.vely
  --math.normalize(self.velX, self.velY)
  self.dir = -1
  self.scale = 0.15
  sheet = love.graphics.newImage(self.animData.runAnimationFile)
  imageDimension = {sheet:getDimensions()}
  self.width = imageDimension[1] / 12
  self.height = imageDimension[2]

  self.RunPlayer(self, self.animData.runAnimationFile)
  self.ShootPlayer(self, self.animData.attackAnimationFile)
  self.DiePlayer(self, self.animData.dieAnimationFile)

  self.body = love.physics.newBody(world, x, y, "dynamic")
  self.body:setLinearDamping(0.75)
  self.shape = love.physics.newRectangleShape((self.width * self.scale)/2, (self.height * self.scale)/2, (self.width * self.scale)/2, (self.height * self.scale) * 0.8) -- ORIGINALLY DIVIDED BY 2
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setUserData(self)

  self.boxWidth = (self.width * self.scale)/2
  self.boxHeight = (self.height * self.scale) * 0.8

  self.canSeePlayer = false
  self.canJump = true
  self.isJumping = false
  self.isGrounded = true
  self.isIdle = true
  self.canShoot = true
  self.isShooting = false

  self.currentHealth = 100
  self.isDead = false
  self.destroy = false;
  groundedRay = {
		x1 = self.x,
		y1 = self.y + self.height * self.scale / 2,
		x2 = self.x,
		y2 = self.y + self.height * self.scale / 2 + 10,
		hitList = {}
	}

  canSeePlayerRay = {
		x1 = self.x,
		y1 = self.y + self.height * self.scale / 2,
		x2 = self.x,
		y2 = self.y + self.height * self.scale / 2 + 10,
		hitList = {}
	}

  self.flip = 1

  self.projectiles = {}

  self.deathsfx = love.audio.newSource("death1.wav", "static")
  self.deathsfx:setLooping(false)
  self.deathsfx:setVolume(1)

end

-----------------------------------------------------------------------
----------------------------CONSTRUCT ANIMATIONS-----------------------

function enemy.DiePlayer(self, sheetFile)
  diePlayer = {}
  diePlayer.sheet = love.graphics.newImage(sheetFile)
  diePlayer.imageDimension = {diePlayer.sheet:getDimensions()}
  diePlayer.grid = anim8.newGrid(self.width, self.height, diePlayer.imageDimension[1], diePlayer.imageDimension[2])
  diePlayer.gridAnimation = anim8.newAnimation(diePlayer.grid('1-15', 1), 0.1, self.OnLoopDie, self)
  self.diePlayer = diePlayer

end

function enemy.ShootPlayer(self, sheetFile)
  shootPlayer = {}
  shootPlayer.sheet = love.graphics.newImage(sheetFile)
  shootPlayer.imageDimension = {shootPlayer.sheet:getDimensions()}
  shootPlayer.grid = anim8.newGrid(self.width, self.height, shootPlayer.imageDimension[1], shootPlayer.imageDimension[2])
  shootPlayer.gridAnimation = anim8.newAnimation(shootPlayer.grid('1-12', 1), 0.025, self.OnLoopShoot, self)
  self.shootPlayer = shootPlayer

end

function enemy.UpdateAnimations(self, dt)
  self.diePlayer.gridAnimation:update(dt)
  self.runPlayer.gridAnimation:update(dt)
  self.shootPlayer.gridAnimation:update(dt)
end

function enemy.RunPlayer(self, sheetFile)
  runPlayer = {}
  runPlayer.sheet = love.graphics.newImage(sheetFile)
  runPlayer.imageDimension = {runPlayer.sheet:getDimensions()}

  runPlayer.grid = anim8.newGrid(self.width, self.height, runPlayer.imageDimension[1], runPlayer.imageDimension[2])
  runPlayer.gridAnimation = anim8.newAnimation(runPlayer.grid('1-12', 1), 0.1, self.OnLoopRun)
  self.runPlayer = runPlayer

end

-------------------------------------------------------------------------
-------------------------ANIM ON LOOP FUNCTIONS--------------------------
function enemy.OnLoopRun(_anim, _loops, self)

end

function enemy.OnLoopShoot(_anim, _loops, self)
  _anim:pauseAtStart()
  if self.isDead == false then
    local newProjectile = {}
    setmetatable(newProjectile, {__index = projectile})
    newProjectile.Construct(newProjectile, self.body:getX() + self.boxWidth / 1.95 + 40 * self.velx, self.body:getY() + 10, self.velx, 0, self.world)
    table.insert(self.projectiles, 1, newProjectile)
  end

end

function enemy.OnLoopDie(_anim, _loops, self)

  if self.isDead == true then
    self.destroy = true
    --self.DestroyPhysics(self)
  else
    _anim:pauseAtStart()
  end
end

-------------------------------------------------------------------------
----------------------------------UPDATE---------------------------------

function enemy.Update(self, dt)
  --player.body.setAngle(player.body, 0)

  if self.velx ~= 0 then
    if self.dir ~= self.flip then
      self.runPlayer.gridAnimation:flipH()
      self.shootPlayer.gridAnimation:flipH()
      self.diePlayer.gridAnimation:flipH()
      self.flip = -self.flip
    end
    --self.dir = self.velx
  end

  enemy.UpdateAnimations(self, dt)
  if self.body ~= nil then
    self.body:setAngle(0)

    enemy.Navigate(self, dt)
    enemy.GroundedCheck(self)
    enemy.UpdateProjectiles(self, dt)


    self.x = self.body:getX()
    self.y = self.body:getY()

    enemy.CanSeePlayerCheck(self)

    if self.isShooting == false and self.canSeePlayer == true then
      self.isShooting = true
      self.shootIntervalTimer = self.shootInterval
      self.shootPlayer.gridAnimation:resume()

    end

    if self.isShooting == true then
      if self.shootIntervalTimer > 0 then
        self.shootIntervalTimer = self.shootIntervalTimer - dt
      else
        self.isShooting = false
      end
    end
  end

end

function enemy.CanSeePlayerCheck(self)

  canSeePlayerRay.hitList = {}
  local nx = self.velx
  local ny = self.vely
  local velNormX, velNormY = math.normalize(nx, ny)
  canSeePlayerRay.x1 = self.x + self.boxWidth / 1.95 * velNormX
  canSeePlayerRay.y1 = self.body:getY() + 10
  canSeePlayerRay.x2 = self.x + 500 * velNormX
  canSeePlayerRay.y2 = self.body:getY() + 10
  self.world:rayCast(canSeePlayerRay.x1, canSeePlayerRay.y1, canSeePlayerRay.x2, canSeePlayerRay.y2, worldRayCastCallbackCanSee)
  if table.getn(canSeePlayerRay.hitList) > 0 then
    if canSeePlayerRay.hitList[1].fixture:getUserData() == player then
      self.canSeePlayer = true
      --print("canSeePlayer")
    else
      self.canSeePlayer = false
      --print("cannot Player")
    end
  else
    self.canSeePlayer = false
    --print("cannot Player")
  end
end

function enemy.UpdateProjectiles(self, dt)


  for i = 1, table.getn(self.projectiles), 1 do
    if self.projectiles[i] ~= nil then
      if self.projectiles[i].isDestroyed == true then
        self.projectiles[i] = nil
      else
        self.projectiles[i].Update(self.projectiles[i], dt)
      end

    end

  end
end

function enemy.Navigate(self, dt)
  self.waypointY1 = self.y
  self.waypointY2 = self.y

  if self.x < self.waypointX1 then

    if self.curWaypointX == self.waypointX1 then
      self.body:setLinearVelocity(0, 0)
      self.curWaypointX = self.waypointX2
      self.curWaypointY = self.waypointY2
      self.dir = 1
    end
    self.velx = self.curWaypointX - self.x
    self.vely = self.curWaypointY - self.y
    local nx = self.velx
    local ny = self.vely
    self.velx, self.vely = math.normalize(nx, ny)
  end

  if self.x > self.waypointX2 then

    if self.curWaypointX == self.waypointX2 then
      self.body:setLinearVelocity(0, 0)
      self.curWaypointX = self.waypointX1
      self.curWaypointY = self.waypointY1
      self.dir = -1
    end
    self.velx = self.curWaypointX - self.x
    self.vely = self.curWaypointY - self.y
    local nx = self.velx
    local ny = self.vely
    self.velx, self.vely = math.normalize(nx, ny)
  end
  --print(self.velx)
  self.body:applyForce(self.velx * self.speed * self.scale * dt, 0)
end

function enemy.GroundedCheck(self)
  groundedRay.hitList = {}

  groundedRay.x1 = self.x + self.width * self.scale / 2
  groundedRay.y1 = self.y + (self.height) * self.scale - 1
  groundedRay.x2 = self.x + self.width * self.scale / 2
  groundedRay.y2 = self.y + (self.height) * self.scale + 10

  self.world:rayCast(groundedRay.x1, groundedRay.y1, groundedRay.x2, groundedRay.y2, worldRayCastCallback)

  groundedRay.x1 = self.x
  groundedRay.y1 = self.y + (self.height) * self.scale - 1
  groundedRay.x2 = self.x
  groundedRay.y2 = self.y + (self.height) * self.scale + 10

  self.world:rayCast(groundedRay.x1, groundedRay.y1, groundedRay.x2, groundedRay.y2, worldRayCastCallback)

  groundedRay.x1 = self.x + self.width * self.scale
  groundedRay.y1 = self.y + (self.height) * self.scale - 1
  groundedRay.x2 = self.x + self.width * self.scale
  groundedRay.y2 = self.y + (self.height) * self.scale + 10

  self.world:rayCast(groundedRay.x1, groundedRay.y1, groundedRay.x2, groundedRay.y2, worldRayCastCallback)

  if table.getn(groundedRay.hitList) > 0 then
    self.isGrounded = true
    self.canJump = true
  else
    self.isGrounded = false
  end
end
function enemy.Draw(self)
  --love.graphics.rectangle("line", player.x, player.y, (player.width) * player.scale, (player.height) * player.scale)

  if self.body ~= nil then love.graphics.rectangle("line", self.body:getX() + (self.width * self.scale / 2 / 2), self.body:getY() + (self.height * self.scale * 0.1), self.width * self.scale / 2, self.height * self.scale * 0.8)
  end

  if self.isDead == true then
    self.diePlayer.gridAnimation:draw(self.diePlayer.sheet, self.x, self.y, 0, self.scale, self.scale, 0, 0)
    return
  end

  if self.isShooting == false then
    self.runPlayer.gridAnimation:draw(self.runPlayer.sheet, self.x, self.y, 0, self.scale, self.scale, 0, 0)
  end

  if self.isShooting == true then
    self.shootPlayer.gridAnimation:draw(self.shootPlayer.sheet, self.x, self.y, 0, self.scale, self.scale, 0, 0)
  end

  for i = 1, table.getn(self.projectiles), 1 do
    if self.projectiles[i] ~= nil then
      self.projectiles[i].Draw(self.projectiles[i])
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

function worldRayCastCallbackCanSee(fixture, x, y, xn, yn, fraction)
	local hit = {}
	hit.fixture = fixture
	hit.x, hit.y = x, y
	hit.xn, hit.yn = xn, yn
	hit.fraction = fraction
	table.insert(canSeePlayerRay.hitList, hit)
	return 1 -- Continues with ray cast through all shapes.
end

function enemy.OnCollisionBegin(a, b)

end
function enemy.TakeDamage(self, damage)
  self:getUserData().currentHealth = self:getUserData().currentHealth - damage
  if self:getUserData().currentHealth <= 0 and self:getUserData().isDead == false then
    self:getUserData().isDead = true
    self:getUserData().deathsfx:play()
    self:getUserData().diePlayer.gridAnimation:resume()
    self:getUserData().DestroyPhysics(self:getUserData())
  end
end

function enemy.DestroyPhysics(self)
  self.fixture:destroy()
  self.fixture = nil
  --a:getUserData().shape:destroy()
  self.body:destroy()
  self.body = nil
end
return player
