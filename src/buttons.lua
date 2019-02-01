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
local buttons = {}
local shuffle_button = {x = -1, y = -1, size = 64, sprite_size = 32, quads = {}}
local random_button = {
  x = -1, y = -1, size = 64, sprite_size = 32,
  base = {}, pips = {},
  left_pip = 1, right_pip = 2, top_pip = 4
}
local decrement_button = {x = -1, y = -1, size = 64}
local increment_button = {x = -1, y = -1, size = 64}
local hint_button = {x = -1, y = -1, size = 64}
local exit_button = {x = -1, y = -1, size = 72}

local function shuffle_button_init()
  shuffle_button.sheet = love.graphics.newImage("shuffle.png")
  local sheet = shuffle_button.sheet
  sheet:setFilter("nearest", "nearest")
  local sheet_width = sheet:getWidth()
  local sheet_height = sheet:getHeight()
  local numb_frames = 21
  local size = shuffle_button.sprite_size
  for i = 1, numb_frames do
    local x = (i - 1) * size
    local y = 0
    local width = size
    local height = width
    local quads = shuffle_button.quads
    quads[i] =
      love.graphics.newQuad(x, y, width, height, sheet_width, sheet_height)
  end
end

shuffle_button_init()

local function die_init()
  random_button.base_sheet = love.graphics.newImage("die.png")
  local sheet = random_button.base_sheet
  sheet:setFilter("nearest", "nearest")
  random_button.base[1] =
    love.graphics.newQuad(0, 0, 32, 32, 32, 32)
  random_button.left_sheet = love.graphics.newImage("die_left.png")
  random_button.left_sheet:setFilter("nearest", "nearest")
  random_button.right_sheet = love.graphics.newImage("die_right.png")
  random_button.right_sheet:setFilter("nearest", "nearest")
  random_button.top_sheet = love.graphics.newImage("die_top.png")
  random_button.top_sheet:setFilter("nearest", "nearest")
  --These three sheets should all be same size.
  local sheet_width = random_button.top_sheet:getWidth()
  local sheet_height = random_button.top_sheet:getHeight()
  for i = 1, 6 do
    local x = (i - 1) * 32
    local y = 0
    local quads = random_button.pips
    quads[i] = love.graphics.newQuad(x, y, 32, 32, sheet_width, sheet_height)
  end
end

die_init()

--This is so ugly but ok for now.
function shuffle_button.place(x, y)
  shuffle_button.x = x
  shuffle_button.y = y
end

function random_button.place(x, y)
  random_button.x = x
  random_button.y = y
end

function increment_button.place(x, y)
  increment_button.x = x
  increment_button.y = y
end

function decrement_button.place(x, y)
  decrement_button.x = x
  decrement_button.y = y
end

function hint_button.place(x, y)
  hint_button.x = x
  hint_button.y = y
end

function exit_button.place(x, y)
  exit_button.x = x
  exit_button.y = y
end

function shuffle_button.update(dt)
end

function shuffle_button.draw()
  love.graphics.setColor(1, 1, 1)
  local x = shuffle_button.x
  local y = shuffle_button.y
  local scale = 2
  local sheet = shuffle_button.sheet
  local quads = shuffle_button.quads
  love.graphics.draw(sheet, quads[1], x, y, 0, scale, scale)
end

function random_button.draw()
  love.graphics.setColor(1, 1, 1)
  local x = random_button.x
  local y = random_button.y
  local scale = 2
  local sheet = random_button.base_sheet
  local quads = random_button.base
  love.graphics.draw(sheet, quads[1], x, y, 0, scale, scale)
  local pips = random_button.pips
  local left_pip = random_button.left_pip
  love.graphics.draw(random_button.left_sheet, pips[left_pip], x, y, 0, scale, scale)
  local right_pip = random_button.right_pip
  love.graphics.draw(random_button.right_sheet, pips[right_pip], x, y, 0, scale, scale)
  local top_pip = random_button.top_pip
  love.graphics.draw(random_button.top_sheet, pips[top_pip], x, y, 0, scale, scale)
end

function increment_button.draw(r, g, b)
  local s = increment_button.size / 2
  local half_s = s / 2
  local x = increment_button.x + half_s
  local y = increment_button.y
  love.graphics.setColor(r, g, b)
  love.graphics.polygon("fill", x + half_s, y, x, y + s, x + s, y + s)
end

function decrement_button.draw(r, g, b)
  local s = decrement_button.size / 2
  local half_s = s / 2
  local x = decrement_button.x + half_s
  local y = decrement_button.y
  love.graphics.setColor(r, g, b)
  love.graphics.polygon("fill", x, y, x + half_s, y + s, x + s, y)
end

function hint_button.draw(r, g, b)
  love.graphics.setColor(r, g, b)
  love.graphics.printf("HINT", hint_button.x, hint_button.y, 64, "center")
end

function exit_button.draw(r, g, b)
  love.graphics.setColor(r, g, b)
  love.graphics.printf("MENU", exit_button.x, exit_button.y, exit_button.size, "left")
end

--We're just going with imaginary dice since we don't have all rotations.
function random_button.randomize()
  local pick = {}
  local picked = {}
  for i = 1, 3 do
    while true do
      local n = love.math.random(6)
      if pick[n] == nil then
        pick[n] = true
        picked[i] = n
        break
      end
    end
  end
  local r = random_button
  r.left_pip = picked[1]
  r.right_pip = picked[2]
  r.top_pip = picked[3]
end

buttons.shuffle = shuffle_button
buttons.random = random_button
buttons.increment = increment_button
buttons.decrement = decrement_button
buttons.hint_button = hint_button
buttons.exit_button = exit_button

return buttons
