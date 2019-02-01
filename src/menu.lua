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
local draw_text = require "font"
local menu = {}
local mouse = {x = -1, y = -1, pressed = false, button = "none", clicked = false, first_click = true}

function menu.init()
end

function menu.update(dt)
end

function menu.draw()
  local mx, my
  mx, my = love.mouse.getPosition()
  love.graphics.clear(1, 1, 1)
  love.graphics.setColor(0, 0, 0)
  local x = 270
  local y = 40
  draw_text("W", x, y, 4)
  draw_text("O", x+50, y, 4)
  draw_text("R", x+100, y, 4)
  draw_text("D", x+150, y, 4)
  draw_text("S", x+200, y, 4)

  x = 300
  y = y + 125
  if point_in_rect(mx, my, x - 50, y - 20, 288, 74) then
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x - 50, y - 20, 288, 74)
    if mouse.clicked then
      mouse.clicked = false
      mouse.first_click = true
      gamestates.current_gamestate = "game"
    end
  end
  love.graphics.setColor(0, 0, 0)
  draw_text("P", x, y, 3)
  draw_text("L", x+50, y, 3)
  draw_text("A", x+100, y, 3)
  draw_text("Y", x+150, y, 3)

  x = 300
  y = y + 100
  if point_in_rect(mx, my, x - 50, y - 20, 288, 74) then
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x - 50, y - 20, 288, 36 * 2 + 2)
    if mouse.clicked then
      mouse.clicked = false
      mouse.first_click = true
      gamestates.current_gamestate = "help"
    end
  end
  love.graphics.setColor(0, 0, 0)
  draw_text("H", x, y, 3)
  draw_text("E", x+50, y, 3)
  draw_text("L", x+100, y, 3)
  draw_text("P", x+150, y, 3)

  x = 220
  y = y + 100
  if point_in_rect(mx, my, x - 50, y - 20, 440, 74) then
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x - 50, y - 20, 440, 36 * 2 + 2)
    if mouse.clicked then
      mouse.clicked = false
      mouse.first_click = true
      gamestates.current_gamestate = "credits"
    end
  end
  love.graphics.setColor(0, 0, 0)
  draw_text("C", x, y, 3)
  draw_text("R", x+50, y, 3)
  draw_text("E", x+100, y, 3)
  draw_text("D", x+150, y, 3)
  draw_text("I", x+200, y, 3)
  draw_text("T", x+250, y, 3)
  draw_text("S", x+300, y, 3)

  x = 300
  y = y + 100
  if point_in_rect(mx, my, x - 50, y - 20, 288, 74) then
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", x - 50, y - 20, 288, 36 * 2 + 2)
    if mouse.clicked then
      love.event.quit()
    end
  end
  love.graphics.setColor(0, 0, 0)
  draw_text("E", x, y, 3)
  draw_text("X", x+50, y, 3)
  draw_text("I", x+100, y, 3)
  draw_text("T", x+150, y, 3)
end

function menu.keypressed(key, scancode, isrepeat)
end

function menu.mousepressed(x, y, button, istouch, presses)
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

function menu.mousereleased(x, y, button, istouch, presses)
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

return menu
