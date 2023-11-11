game_scene = {}
local pd <const> = playdate
local gfx <const> = playdate.graphics

game_scene.setup = function(context, init_params)
  UPDATE = game_scene.update
  DRAW = game_scene.draw
  return context
end

game_scene.update = function(context)
  return context
end

game_scene.draw = function(context)
  gfx.clear()
  gfx.drawText("and now what?", 50, 50)
end

