--require "Player"
menu = require("Menu")
gs = require("GameScene")
currentScene = {}
function love.load(arg)
  -- body --

  love.window.setMode(1200, 640)

  currentScene = menu

  --WalkPlayer(0, 0)


  print("Main")
  menu.Construct()
  --gs.Construct()
end

function love.update(dt)
  -- body...
  currentScene.Update(dt)


end

function love.draw()
  -- body...



  --player.walkPlayer.walkGridAnimation:draw(player.walkPlayer.walkSheet, player.walkPlayer.x, player.walkPlayer.y, 0, 0.25, 0.25, player.walkPlayer.width/2, player.walkPlayer.height/2)
  currentScene.Draw()

end

function ChangeScene(_name)
  if currentScene.Destruct() ~= nil then currentScene.Destruct() end
  currentScene = nil
  if _name == "GameScene" then
    gs.Construct(selectedPlayerData)
    currentScene = gs;
  end
  if _name == "Menu" then menu.Construct() currentScene = menu end
end
