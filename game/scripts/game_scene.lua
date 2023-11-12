game_scene = {}
local pd <const> = playdate
local gfx <const> = playdate.graphics

local PLAYER_WIDTH <const> = 8
local PLAYER_HEIGHT <const> = 8
local SCREEN_WIDTH <const> = pd.display.getWidth()
local SCREEN_HEIGHT <const> = pd.display.getHeight()
local BARRIER_GAP <const> = PLAYER_HEIGHT * 3
local INITIAL_HEALTH <const> = 3
local INITIAL_TIMER <const> = 30 * 60
local UI_HEIGHT <const> = 18
local GAME_STATES = {
  START = 1,
  RUNNING = 2,
  GAME_OVER = 3,
}

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

local any_button_just_pressed = function()
  local buttons = {
    pd.kButtonA,
    pd.kButtonB,
    pd.kButtonUp,
    pd.kButtonDown,
    pd.kButtonLeft,
    pd.kButtonRight,
  }
  local result = false

  for _, button in pairs(buttons) do
    result = result or pd.buttonJustPressed(button)
  end

  return result
end

local barrier_can_be_passed = function(barrier, player)
  local touches_higher_barrier = player.pos_y < barrier.pos_y
  local touches_lower_barrier = player.pos_y + PLAYER_HEIGHT > barrier.pos_y + BARRIER_GAP

  return (not touches_higher_barrier) and (not touches_lower_barrier)
end

local generate_new_barrier = function()
  local from_y = PLAYER_HEIGHT + UI_HEIGHT
  local to_y = SCREEN_HEIGHT - (BARRIER_GAP + PLAYER_HEIGHT)
  return {
    pos_y = math.random(from_y, to_y)
  }
end

local generate_new_barriers = function(how_many)
  local barriers = {}
  for i = 1, (how_many + 1) do
    table.insert(barriers, generate_new_barrier())
  end
  return barriers
end

local poppush_barriers = function(old_barriers)
  local new_barriers = {}
  local how_many = #old_barriers

  for i = 2, how_many + 1 do
    table.insert(new_barriers, old_barriers[i])
  end

  table.insert(new_barriers, generate_new_barrier())

  return new_barriers
end

local handle_game_running_input = function(context)
  -- handling vertical movement
  local min_y = UI_HEIGHT
  local max_y = SCREEN_HEIGHT - PLAYER_HEIGHT
  local player = context.player
  local change, accelerated_change = pd.getCrankChange()
  local delta_y = degree_change_to_cartesian_change(change)
  player.pos_y = minmax(player.pos_y + delta_y, min_y, max_y)

  -- handling horizontal
  local barriers = context.barriers
  local barrier = barriers[1]
  if any_button_just_pressed() then
    context.state = GAME_STATES.RUNNING
    if barrier_can_be_passed(barrier, player) then
      barriers = poppush_barriers(barriers)
      context.score = context.score + 1
    else
      player.health = player.health - 1
    end
  end
  
  context.player = player
  context.barriers = barriers
  return context
end

local update_running_game_state = function(context)
  if context.state == GAME_STATES.RUNNING and context.timer > 0 then
    context.timer = context.timer - 1
  end

  if context.timer <= 0 or context.player.health <= 0 then
    context.is_new_high_score = high_score_model.maybe_set_high_score(context.score)
    context.state = GAME_STATES.GAME_OVER
  end

  return context
end

local build_ui_text = function(context)
  local outlet = ""
  
  outlet = outlet .. "LIVES: " .. context.player.health
  outlet = outlet .. " TIMER: " .. context.timer
  outlet = outlet .. " SCORE: " .. context.score

  return outlet
end

local build_game_over_text = function(context)
  local game_over_message = "GAME OVER!"
  local score_message = " SCORE: "

  if context.timer <= 0 then
    game_over_message = "YOUR TIME IS UP!"
  end

  if context.is_new_high_score then
    score_message = " NEW HIGH SCORE: "
  end

  return game_over_message .. score_message .. context.score
end

local handle_game_over_input = function(context)
  if any_button_just_pressed() then
    context = main_menu_scene.setup() 
  end
  return context
end

-- ###################
-- # MAIN OPERATIONS #
-- ###################

game_scene.setup = function(context, init_params)
  UPDATE = game_scene.update
  DRAW = game_scene.draw
  context = {
    state = GAME_STATES.START,
    player = {
      pos_y = SCREEN_HEIGHT/2 - PLAYER_HEIGHT/2,
      health = INITIAL_HEALTH,
    },
    barriers = generate_new_barriers(20),
    score = 0,
    timer = INITIAL_TIMER,
    is_new_high_score = false,
  }
  return context
end

game_scene.update = function(context)
  local state = context.state

  if state == GAME_STATES.GAME_OVER then
    context = handle_game_over_input(context)
  else
    context = handle_game_running_input(context)
    context = update_running_game_state(context)
  end

  return context
end

game_scene.draw = function(context)
  local x = 0
  local y = 0
  local w = 0
  local h = 0
  local r = 2
  local t = ""
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
  for n, barrier in pairs(barriers) do
    -- drawing higher barrier
    x = 30 * n
    y = -10
    w = 10
    h = barrier.pos_y + 10
    gfx.drawRoundRect(x, y, w, h, r)

    -- drawing lower barrier
    y = barrier.pos_y + BARRIER_GAP
    h = SCREEN_HEIGHT - y + 10 
    gfx.drawRoundRect(x, y, w, h, r)
  end

  -- drawing UI
  t = build_ui_text(context)
  gfx.fillRect(0, 0, SCREEN_WIDTH, UI_HEIGHT)
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawText(t, 1, 1)
  gfx.setImageDrawMode(gfx.kDrawModeFillBlack)

  if context.state == GAME_STATES.GAME_OVER then
    x = SCREEN_WIDTH / 8
    y = SCREEN_HEIGHT / 4
    w = SCREEN_WIDTH * 3 / 4
    h = SCREEN_HEIGHT / 2
    gfx.fillRoundRect(x, y, w, h, r)

    t = build_game_over_text(context)
    w, h = gfx.drawText(t, x + 6, y + 6)
    x = SCREEN_WIDTH/2 - w/2
    y = SCREEN_HEIGHT/2 - h/2
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawText(t, x, y)
    gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
  end
end

