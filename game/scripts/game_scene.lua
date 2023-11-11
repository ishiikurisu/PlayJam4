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

local generate_new_barrier = function()
  local from_y = PLAYER_HEIGHT
  local to_y = SCREEN_HEIGHT - 3*PLAYER_HEIGHT
  return {
    pos_y = math.random(from_y, to_y)
  }
end

local generate_new_barriers = function(how_many)
  local barriers = {}
  for i = 1, (how_many + 1) do
    table.insert(barriers, generate_new_barrier)
  end
  return barriers
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
    barriers = generate_new_barriers(10),
  }
  return context
end

game_scene.update = function(context)
  context = handle_game_running_input(context)
  return context
end

game_scene.draw = function(context)
  local x = 0
  local y = 0
  local w = 0
  local h = 0
  local r = 2
  gfx.clear()

  -- drawing player character
  local player = context.player
  x = 10
  y = player.pos_y
  w = PLAYER_WIDTH
  h = PLAYER_HEIGHT
  gfx.fillRoundRect(x, y, w, h, r)

  -- drawing barriers
  local barriers = context.barriers
  for n, barrier in range(barriers) do
    -- drawing higher barrier
    x = 20 * n
    y = -10
    w = 10
    h = barrier.pos_y + 10
    gfx.drawRoundRect(x, y, w, h, r)

    -- TODO draw lower barrier
  end
end

