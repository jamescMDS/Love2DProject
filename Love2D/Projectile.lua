projectile = {}

function projectile.Construct(self, x, y, vx, vy)
  self.thisclass = self
  self.vx = vx
  self.vy = vy
  self.x = x
  self.y = y
  self.scale = 0.6
  sheet = love.graphics.newImage('Pink_Projectile.png')
  imageDimension = {sheet:getDimensions()}
  self.width = imageDimension[1] / 8
  self.height = imageDimension[2] / 8
  self.isDestroyed = false
  self.ShootProjectile(self)

  self.body = love.physics.newBody(gameScene.world, self.x, self.y, "dynamic")
  self.body:setGravityScale(0)
  --projectile.body:setLinearDamping(0.75)
  self.shape = love.physics.newRectangleShape((self.width * self.scale)/2, (self.height * self.scale)/2, (self.width * self.scale) / 2, ((self.height) * self.scale)/2) -- ORIGINALLY DIVIDED BY 2
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setUserData(self)

  self.body:applyLinearImpulse(self.vx * 70, (self.vy * 1000))

  self.id = 0
end

function projectile.Update(self, dt)

  if self.isDestroyed == false then
    self.shootProjectile.gridAnimation:update(dt)
    --projectile.body:applyForce(projectile.vx * 7000 * dt, (projectile.vy * 1000) * dt)

    self.x = self.body:getX()
    self.y = self.body:getY()
  end

end

function projectile.Draw(self)
  if self.body == nil then
    return
  end
  self.shootProjectile.gridAnimation:draw(self.shootProjectile.sheet, self.x, self.y, 0, self.scale, self.scale, 0, 0)
end
function projectile.ShootProjectile(self)
  shootProjectile = {}
  shootProjectile.sheet = love.graphics.newImage('Pink_Projectile.png')
  shootProjectile.imageDimension = {shootProjectile.sheet:getDimensions()}

  shootProjectile.grid = anim8.newGrid(self.width, self.height, shootProjectile.imageDimension[1], shootProjectile.imageDimension[2])
  shootProjectile.gridAnimation = anim8.newAnimation(shootProjectile.grid('1-8', 1, '1-8', 2, '1-8', 3, '1-8', 4, '1-8', 5, '1-8', 6, '1-8', 7, '1-8', 8), 0.1)
  shootProjectile.gridAnimation:flipH()
  self.shootProjectile = shootProjectile

end

function projectile.OnCollisionBegin(a, b)
  if a:getUserData().fixture == nil then
    return
  end
  print("projectile Collision")
  if b:getUserData().TakeDamage ~=nil then
    b:getUserData().TakeDamage(b, 50)
  end
  print("destroy start")

  a:getUserData().fixture:destroy()
  a:getUserData().fixture = nil
  --a:getUserData().shape:destroy()
  a:getUserData().body:destroy()
  a:getUserData().body = nil
  print("destroy end")
  a:getUserData().isDestroyed = true
end

return projectile
