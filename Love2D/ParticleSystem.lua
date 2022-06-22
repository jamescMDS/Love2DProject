particleSystem = {}

function particleSystem.Construct(self, imagefile, buffer, emitLifetime, particleLifetimeMin, particleLifetimeMax, rate)
  img = love.graphics.newImage(imagefile)
  self.system = love.graphics.newParticleSystem(img, buffer)
  self.system:setEmitterLifetime(emitLifetime)
  self.system:setEmissionRate(rate)
  self.system:setParticleLifetime(particleLifetimeMin, particleLifetimeMax)
  self.system:setEmissionArea("uniform", 500, 25, 0, false)
  self.system:setLinearAcceleration(-45, -100, 45, -100)
  self.system:setRadialAcceleration(-45, 45)
  --self.system:setTangentialAcceleration(-45, 45)
  self.system:setSpeed(0, -100)
  self.system:setSpeed(5)
end


return particleSystem
