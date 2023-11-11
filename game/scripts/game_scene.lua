game_scene = {}
local pd <const> = playdate
local gfx <const> = playdate.graphics

local PLAYER_WIDTH <const> = 8
local PLAYER_HEIGHT <const> = 8

game_scene.setup = function(context, init_params)
  UPDATE = game_scene.update
  DRAW = game_scene.draw
  context = {
    state = "start",
    player = {
      pos_y = playdate.display.getHeight()/2 - PLAYER_HEIGHT/2,
    },
  }
  return context
end

game_scene.update = function(context)
  return context
end

game_scene.draw = function(context)
  gfx.clear()

  -- drawing player character
  local player = context.player
  local pos_x = 10
  local pos_y = player.pos_y
  gfx.fillRoundRect(pos_x, pos_y, PLAYER_WIDTH, PLAYER_HEIGHT, 2)
end

