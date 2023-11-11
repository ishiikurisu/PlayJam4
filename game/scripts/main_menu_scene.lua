main_menu_scene = {}
local pd <const> = playdate
local gfx <const> = playdate.graphics

main_menu_scene.setup = function(context, input_params)
  UPDATE = main_menu_scene.update
  DRAW = main_menu_scene.draw
  return context
end

main_menu_scene.update = function(context)
  if pd.buttonIsPressed(pd.kButtonA) then
    context = game_scene.setup(context, {})
  end
  return context
end

main_menu_scene.draw = function(context)
  local high_score = 0  -- TODO implement high score!

  gfx.clear()
  gfx.drawText("PLEASE GIVE ME A NAME", 50, 50)
  gfx.drawText("- Use the dock to move up and down", 50, 70)
  gfx.drawText("- Press any button to move right", 50, 90)
  gfx.drawText("- Surpass as many barriers as possible in 60s", 50, 110)
  gfx.drawText("Press any button to start and good luck!", 50, 150)
  gfx.drawText("HIGH SCORE: " .. high_score, 50, 170)
end

