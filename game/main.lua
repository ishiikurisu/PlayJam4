import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/main_menu_scene"
import "scripts/game_scene"

SETUP = main_menu_scene.setup

local gfx <const> = playdate.graphics
local context = SETUP({}, {})

function playdate.update()
  context = UPDATE(context)
  DRAW(context)
  gfx.sprite.update()
  playdate.timer.updateTimers()
end

