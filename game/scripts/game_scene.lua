game_scene = {}
local pd <const> = playdate
local gfx <const> = playdate.graphics

local PLAYER_WIDTH <const> = 8
local PLAYER_HEIGHT <const> = 8
local SCREEN_HEIGHT <const> = pd.display.getHeight()

-- #######################
-- # AUXILIARY FUNCTIONS #
-- #######################

local minmax = function(x, floor, ceil)
  local y = x
  if y > ceil then
    y = ceil
  end
  if y < floor then
    y = floor
  end
  return y
end

local degree_change_to_cartesian_change = function(dg)
  -- screen_size / 360 degrees = screen_dx / delta_degrees
  -- therefore screen_dx = delta_degress * screen_size / 360 degrees
  return dg * pd.display.getHeight() / 360
end

local handle_game_running_input = function(context)
  local player = context.player
  local change, accelerated_change = pd.getCrankChange()
  local delta_y = degree_change_to_cartesian_change(change)
  player.pos_y = minmax(player.pos_y + delta_y, 0, SCREEN_HEIGHT - PLAYER_HEIGHT)
  return context
end


-- ###################
-- # MAIN OPERATIONS #
-- ###################

game_scene.setup = function(context, init_params)
  UPDATE = game_scene.update
  DRAW = game_scene.draw
  context = {
    state = "start",
    player = {
      pos_y = SCREEN_HEIGHT/2 - PLAYER_HEIGHT/2,
    },
  }
  return context
end

game_scene.update = function(context)
  context = handle_game_running_input(context)
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

