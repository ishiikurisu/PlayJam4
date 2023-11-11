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
  gfx.clear()
  gfx.drawText("PLEASE GIVE ME A NAME", 50, 50)
end

