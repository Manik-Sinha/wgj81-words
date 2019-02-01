--[[
Words is a word game about rearranging letters to make words in rows.

Copyright (C) 2019 Manik Sinha

This file is part of Words.

Words is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

Website:    https://manik-sinha.itch.io/wgj81-words
Sourcecode: https://github.com/Manik-Sinha/wgj81-words
Author:     Manik Sinha
E-mail:     ManikSinha@protonmail.com
Devlogs:    https://manik-sinha.itch.io/wgj81-words/devlog
--]]
--local draw_text = require "font"
local help = {}
local mouse = {x = -1, y = -1, pressed = false, button = "none", clicked = false, first_click = true}

function help.init()
end

function help.update(dt)
end

function help.draw()
  local mx, my
  mx, my = love.mouse.getPosition()
  love.graphics.clear(1, 1, 1)
  love.graphics.setColor(0, 0, 0)
  local x = 0
  local y = 80
  local dist = 30

  --[[
    Click on a letter to select it. Click on another letter to move your letter to that position.
    Make a word in every row to win!

    You can also click the buttons on the side.

    They let you shuffle the board if you need a fresh perspective.
    Generate a new puzzle if this one's too hard or you won.
    Increase the number of letters in the puzzle.
    Decrease the number of letters in the puzzle.
    Give one hint word.
    Go back to the Main Menu.

    The buttons on the right side allow you to; reshuffle the puzzle, increase or decrease the difficulty, get a hint or even go back to the main menu.
  --]]
  love.graphics.printf("Click on a letter to select it.", x, y, window_width, "center")
  y = y + dist
  love.graphics.printf("Click on another letter to move your letter to that position.", x, y, window_width, "center")
  y = y + dist
  love.graphics.printf("Make a word in every row to win!", x, y, window_width, "center")

  y = y + 60
  love.graphics.printf("You can also click the buttons on the side.", x, y, window_width, "center")

  y = y + 60
  love.graphics.printf("They let you shuffle the board if you need a fresh perspective.", x, y, window_width, "center")
  y = y + dist
  love.graphics.printf("Generate a new puzzle if this one's too hard or you won.", x, y, window_width, "center")
  y = y + dist
  love.graphics.printf("Increase the number of letters in the puzzle.", x, y, window_width, "center")
  y = y + dist
  love.graphics.printf("Decrease the number of letters in the puzzle.", x, y, window_width, "center")
  y = y + dist
  love.graphics.printf("Give one word as a hint.", x, y, window_width, "center")
  y = y + dist
  love.graphics.printf("Go back to the Main Menu.", x, y, window_width, "center")

  y = window_height - 100
  if point_in_rect(mx, my, window_width / 2 - 36, y, 76, 32) then
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", window_width / 2 - 36, y, 76, 32)
    if mouse.clicked then
      mouse.clicked = false
      mouse.first_click = true
      gamestates.current_gamestate = "menu"
    end
  end
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Back", x, y, window_width, "center")
end

function help.keypressed(key, scancode, isrepeat)
  if scancode == "escape" then
    gamestates.current_gamestate = "menu"
  end
end

function help.mousepressed(x, y, button, istouch, presses)
  mouse.x = x
  mouse.y = y
  if button == 1 then
    mouse.button = "left"
  elseif button == 2 then
    mouse.button = "right"
  else
    mouse.button = "none"
  end
  if mouse.first_click then
    mouse.clicked = true
  else
    mouse.clicked = false
  end
  --print("clicked " .. tostring(mouse.clicked))
  mouse.first_click = false
  mouse.pressed = true
end

function help.mousereleased(x, y, button, istouch, presses)
  mouse.x = x
  mouse.y = y
  if button == 1 then
    mouse.button = "left"
  elseif button == 2 then
    mouse.button = "right"
  else
    mouse.button = "none"
  end
  mouse.pressed = false
  mouse.clicked = false
  mouse.first_click = true
end

return help
