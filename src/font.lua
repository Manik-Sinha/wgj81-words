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
local font_sheet = nil
local alphabet = {
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
  "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
}
local quads = {}

local function init()
  font_sheet = love.graphics.newImage("letters.png")
  font_sheet:setFilter("nearest", "nearest")
  local sheet_width = font_sheet:getWidth()
  local sheet_height = font_sheet:getHeight()
  for i = 1, #alphabet do
    local x = (i - 1) * 12 + (26 * 12)
    local y = 0
    local width = 12
    local height = 12
    local letter = alphabet[i]
    local quad =
      love.graphics.newQuad(x, y, width, height, sheet_width, sheet_height)
    quads[letter] = quad
    quads[string.lower(letter)] = quad
  end
end

init()

local function draw_text(letter, x, y, s)
  if s == nil then s = 1 end
  love.graphics.draw(font_sheet, quads[letter], x, y, 0, s, s)
end

local function draw_block(letter, x, y, rb, gb, bb, rt, gt, bt, kind)
  if kind ~= "fill" and kind ~= "line" then
    kind = "line"
  end
  local scale = 3
  local sprite_width = 12
  local letter_width = scale * sprite_width
  local extraspace = letter_width * 0.5
  local blocksize = letter_width + extraspace
  local x = x - blocksize / 2
  local y = y - blocksize / 2
  love.graphics.setColor(rb, gb, bb)
  love.graphics.rectangle(kind, x + 0.5, y + 0.5, blocksize, blocksize)
  love.graphics.setColor(rt, gt, bt)
  draw_text(letter, x + extraspace / 2, y + extraspace / 2, scale)
end

--[[
function love.draw()
  love.graphics.clear(1, 1, 1)
  love.graphics.setColor(0, 0, 0)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  draw_block(width / 2, height / 2)
end
--]]
return draw_text
