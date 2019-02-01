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
local credits = {}
local mouse = {x = -1, y = -1, pressed = false, button = "none", clicked = false, first_click = true}

function credits.init()
end

function credits.update(dt)
end

function credits.draw()
  local mx, my
  mx, my = love.mouse.getPosition()
  love.graphics.clear(1, 1, 1)
  love.graphics.setColor(0, 0, 0)
  local x, y
  x = 0
  y = 20
  love.graphics.printf("Words is based on a concept by Manik Sinha", x, y, window_width, "center")
  y = y + 120
  love.graphics.printf("Manik Sinha: Programming, Game Design", x, y, window_width, "center")
  y = y + 50
  love.graphics.printf("Mibombo: Art, Game Design", x, y, window_width, "center")
  y = y + 100

  if point_in_rect(mx, my, window_width / 2 - 250, y - 10, 498, 52) then
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", window_width / 2 - 250, y - 10, 498, 52)
    if mouse.clicked then
      mouse.clicked = false
      mouse.first_click = true
      love.system.openURL("https://manik-sinha.itch.io/wgj81-words")
    end
  end
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("https://manik-sinha.itch.io/wgj81-words", x, y, window_width, "center")

  y = y + 100
  love.graphics.printf("This game was made for the Weekly Game Jam (Week 81)", x, y, window_width, "center")
  y = y + 50

  if point_in_rect(mx, my, window_width / 2 - 180, y - 10, 360, 52) then
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", window_width / 2 - 180, y - 10, 360, 52)
    if mouse.clicked then
      mouse.clicked = false
      mouse.first_click = true
      love.system.openURL("http://weeklygamejam.com")
    end
  end
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("http://weeklygamejam.com", x, y, window_width, "center")
  y = y + 80

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

function credits.keypressed(key, scancode, isrepeat)
  if scancode == "escape" then
    gamestates.current_gamestate = "menu"
  end
end

function credits.mousepressed(x, y, button, istouch, presses)
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

function credits.mousereleased(x, y, button, istouch, presses)
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

return credits
