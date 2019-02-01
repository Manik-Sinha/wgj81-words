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
love.graphics.clear(1, 1, 1)
love.graphics.setColor(0, 0, 0)
love.graphics.setFont(love.graphics.newFont(24))
love.graphics.print("Loading...", love.graphics.getWidth() / 2.4, love.graphics.getHeight() / 2.2)
love.graphics.present()

redcolor = {r = 0.83, g = 0.32, b = 0.32}

local game = require 'game'
local menu = require 'menu'
local credits = require 'credits'
local help = require 'help'
gamestates = {}
gamestates.game = game
gamestates.menu = menu
gamestates.credits = credits
gamestates.help = help
gamestates.current_gamestate = "menu"

function love.load()
  window_width = love.graphics.getWidth()
  window_height = love.graphics.getHeight()
  local font = love.graphics.newFont(24)
  love.graphics.setFont(font)
  game.init()
  menu.init()
  credits.init()
  help.init()
end

function love.update(dt)
  gamestates[gamestates.current_gamestate].update(dt)
end

function love.draw()
  gamestates[gamestates.current_gamestate].draw()
end

function love.keypressed(key, scancode, isrepeat)
  if scancode == "escape" then
    --love.event.quit()
    if gamestates.current_gamestate == "game" then
      current_gamestate = "menu"
    elseif gamestates.current_gamestate == "menu" then
      love.event.quit()
    end
  end
  --elseif scancode == "f" then
    --TODO: When switching it looks bad; fix.
  --  love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
  --end
  gamestates[gamestates.current_gamestate].keypressed(key, scancode, isrepeat)
end

function love.mousepressed(x, y, button, istouch, presses)
  gamestates[gamestates.current_gamestate].mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
  gamestates[gamestates.current_gamestate].mousereleased(x, y, button, istouch, presses)
end

function love.resize(w, h)
  window_width = love.graphics.getWidth()
  window_height = love.graphics.getHeight()
  --game.resize(w, h)
end
