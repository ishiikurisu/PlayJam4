main_menu_scene = {}
local pd <const> = playdate
local gfx <const> = playdate.graphics

main_menu_scene.setup = function(context, input_params)
  UPDATE = main_menu_scene.update
  DRAW = main_menu_scene.draw
  return context
end

main_menu_scene.update = function(context)
  if pd.buttonJustPressed(pd.kButtonA) and not pd.isCrankDocked() then
    context = game_scene.setup(context, {})
  end
  return context
end

main_menu_scene.draw = function(context)
  local high_score = high_score_model.get_high_score()

  gfx.clear()
  gfx.drawText("PLEASE GIVE ME A NAME", 10, 10)
  gfx.drawText("- Use the dock to move up and down", 10, 30)
  gfx.drawText("- Press any button to move right", 10, 50)
  gfx.drawText("- Surpass as many barriers as possible in 60s", 10, 70)
  gfx.drawText("- Undock the crank and press A to start", 10, 90)
  gfx.drawText("GOOD LUCK!", 10, 130)
  gfx.drawText("HIGH SCORE: " .. high_score, 10, 150)

  if playdate.isCrankDocked() then
    playdate.ui.crankIndicator:draw()
  end
end

