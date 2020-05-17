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
require "words"
local draw_text = require "font"
local default_font = love.graphics.getFont()
local roboto_font = love.graphics.newFont("/font/Roboto-Regular.ttf", 32)
local roboto_font_large = love.graphics.newFont("/font/Roboto-Regular.ttf", 55)
local buttons = require "buttons"
local shuffle_button = buttons.shuffle
local random_button = buttons.random
local decrement_button = buttons.decrement
local increment_button = buttons.increment
local hint_button = buttons.hint_button
local exit_button = buttons.exit_button
local game = {}
local mouse = {x = -1, y = -1, pressed = false, button = "none", clicked = false, first_click = true}
local grid = {}
local gamesize = 4
local hint_button_pressed = false
local animation_lock
local won_game = false

local function start_shuffling(grid)
  if animation_lock == false then
    animation_lock = true
    grid.shaking = true
    grid.shaking_timer = 30
    grid.shaking_to_randomize = false
  end
end

local function start_randomizing(grid)
  if animation_lock == false then
    animation_lock = true
    grid.shaking = true
    grid.shaking_timer = 30
    grid.shaking_to_randomize = true
  end
end

local function shuffle(grid)
  local first_index = 1 * grid.cols + 1
  local last_index = grid.rows * grid.cols + grid.cols
  while last_index ~= first_index do
    local random_index = love.math.random(first_index, last_index)
    grid[random_index], grid[last_index] = grid[last_index], grid[random_index]
    last_index = last_index - 1
  end
end

local function decompose_word(word)
  local t = {string.byte(word, 1, #word)}
  for i = 1, #t do
    t[i] = string.upper(string.char(t[i]))
  end
  return t
end

local function recompose_word(table_of_chars)
  local s = ""
  for i = 1, #table_of_chars do
    s = s .. table_of_chars[i]
  end
  return s
end

local function get_hint(grid)
  if not grid.hint_word_locked then
    grid.hint_word_locked = true

    local words = {}
    for row = 1, grid.rows do
      local word = ""
      for i = 1, grid.cols do
        word = word .. grid[row * grid.cols + i]
      end
      words[row] = word
    end

    local new_hint_word_required = false
    local bad_word_index = -1
    for i = 1, #words do
      if words[i] == grid.hint_word then
        new_hint_word_required = true
        bad_word_index = i
      end
    end

    if new_hint_word_required then
      words[bad_word_index], words[#words] = words[#words], words[bad_word_index]
      grid.hint_word = words[love.math.random(#words - 1)]
    end
  end
  return grid.hint_word
end

function game.init()
  animation_lock = false
  hint_button_pressed = false
  grid = {}
  grid.rows = gamesize
  grid.cols = grid.rows
  grid.selected_tile = nil
  grid.words = {}
  grid.hints = {}
  grid.hint_word = ""
  grid.hint_word_locked = false
  grid.shaking = false
  grid.shaking_timer = 0
  grid.shaking_to_randomize = false
  local words = {}
  local word_count = 0
  local wlist = wordlist[gamesize]
  while word_count < grid.rows do
    local word = wlist[love.math.random(1, #wlist)]
    if words[word] == nil then
      words[word] = decompose_word(word)
      word_count = word_count + 1
      for i = 1, grid.cols do
        local row = word_count
        local index = row * grid.cols + i
        grid[index] = words[word][i]
        grid.words[row] = word
        grid.hints[word] = word
      end
    end
  end

  grid.hint_word = grid.words[love.math.random(#grid.words)]
  --[[
  for word in pairs(words) do
    print(word)
  end
  for row = 1, grid.rows do
    for col = 1, grid.cols do
      local index = row * grid.cols + col
      io.write(grid[index], " ")
    end
    print()
  end
  print()
  --]]

  --Make sure we don't start a game with a row already complete.
  --Theoretically this could loop forever so that's why we try again if it fails
  --after 100 attempts.
  local iterations = 0
  repeat
    shuffle(grid)
    local function every_row_is_scrambled()
      for row = 1, grid.rows do
        local word = ""
        for i = 1, grid.cols do
          word = word .. grid[row * grid.cols + i]
        end
        if wordlist_hash[word] ~= nil then
          return false
        end
      end
      return true
    end
    iterations = iterations + 1
    if iterations > 100 then
      game.init()
    end
  until every_row_is_scrambled()

  --[[
  for row = 1, grid.rows do
    for col = 1, grid.cols do
      local index = row * grid.cols + col
      io.write(grid[index], " ")
    end
    print()
  end
  --]]
  local place_y = 120
  shuffle_button.place(window_width - shuffle_button.size * 1.25, place_y)
  place_y = place_y + shuffle_button.size
  random_button.place(window_width - random_button.size * 1.25, place_y)
  place_y = place_y + random_button.size + increment_button.size / 4
  increment_button.place(window_width - increment_button.size * 1.25, place_y)
  place_y = place_y + increment_button.size / 1.5
  decrement_button.place(window_width - decrement_button.size * 1.25, place_y)
  place_y = place_y + decrement_button.size / 1.5
  hint_button.place(window_width - hint_button.size * 1.25, place_y)
  place_y = place_y + hint_button.size / 1.5
  exit_button.place(window_width - exit_button.size * 1.15, place_y)
end

local dtsum = 0
function game.update(dt)
  if animation_lock then
    if grid.shaking then
      --grid.shaking_timer = grid.shaking_timer - 1
      dtsum = dtsum + dt
      --if grid.shaking_timer == 0 then
      if dtsum > 0.5 then
        dtsum = 0
        if grid.shaking_to_randomize then
          game.init()
          random_button.randomize()
        else
          shuffle(grid)
        end
        grid.shaking = false
        grid.shaking_to_randomize = false
        animation_lock = false
        --Really ugly but...
        grid.selected_tile = nil
      end
    end
  end
end

function point_in_square(mx, my, x, y, s)
  return not (mx < x or mx > (x + s) or my < y or my > (y + s))
end

function point_in_rect(mx, my, x, y, w, h)
  return not (mx < x or mx > (x + w) or my < y or my > (y + h))
end

function game.draw()
  love.graphics.clear(1, 1, 1)
  love.graphics.setColor(0, 0, 0)
  local row_matches = false
  --local col_matches = false
  local count_matching_rows = 0
  for row = 1, grid.rows do
    local word = ""
    for i = 1, grid.cols do
      word = word .. grid[row * grid.cols + i]
    end
    if wordlist_hash[word] ~= nil then
      row_matches = true
      count_matching_rows = count_matching_rows + 1
    else
      row_matches = false
    end
    for col = 1, grid.cols do
      --[[
      local column_word = ""
      for i = 1, grid.rows do
        column_word = column_word .. grid[i * grid.cols + col]
      end
      if wordlist_hash[column_word] ~= nil then
        column_matches = true
      else
        column_matches = false
      end
      --]]
      local size = 80
      local spacing = 20
      local half_grid_width = (size * grid.cols + spacing * (grid.cols - 1)) / 2
      local half_grid_height = (size * grid.rows + spacing * (grid.rows - 1)) / 2
      local x = (col - 1) * (size + spacing) + window_width / 2.0 - half_grid_width
      local y = (row - 1) * (size + spacing) + window_height / 2.0 - half_grid_height
      if grid.shaking == true then
        local n = 2
        x = x + love.math.random(-n, n)
        y = y + love.math.random(-n, n)
        --grid.selected_tile = nil
      end
      local index = row * grid.cols + col
      if row_matches then --or column_matches then
        ---[[
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", x, y, size, size)
        love.graphics.setColor(1, 1, 1)
        if not grid.shaking_to_randomize then
          --love.graphics.print(grid[index], x + size / 2 - 9, y + size / 2 - 11)
          --draw_text(grid[index], x + size / 2 - 18, y + size / 2 - 18, 3)
          love.graphics.setFont(roboto_font_large)
          love.graphics.printf(grid[index], x - 10, y + 8, 100, "center")
          love.graphics.setFont(default_font)
        end
        --]]
        --draw_block(grid[index], x, y, 0, 0, 0, 1, 1, 1, "fill")
      elseif grid.selected_tile ~= index then
        ---[[
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", x, y, size, size)
        if not grid.shaking_to_randomize then
          --love.graphics.print(grid[index], x + size / 2 - 9, y + size / 2 - 11)
          --draw_text(grid[index], x + size / 2 - 12, y + size / 2 - 12, 2)
          love.graphics.setFont(roboto_font)
          love.graphics.printf(grid[index], x - 10, y + 22, 100, "center")
          love.graphics.setFont(default_font)
        end
        --]]
        --draw_block(grid[index], x, y, 0, 0, 0, 0, 0, 0, "line")
      end
      if grid.selected_tile == index then
        ---[[
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", x, y, size, size)
        love.graphics.setColor(1, 1, 1)
        if not grid.shaking_to_randomize then
          --love.graphics.print(grid[index], x + size / 2 - 9, y + size / 2 - 11)
          --draw_text(grid[index], x + size / 2 - 18, y + size / 2 - 18, 3)
          love.graphics.setFont(roboto_font_large)
          love.graphics.printf(grid[index], x - 10, y + 8, 100, "center")
          love.graphics.setFont(default_font)
        end
        --]]
        --draw_block(grid[index], x, y, 0.5, 0.5, 0.5, 1, 1, 1, "fill")
      end
      if mouse.clicked and not grid.shaking then
        if point_in_square(mouse.x, mouse.y, x, y, size) then
          mouse.clicked = false
          --print("selected row ".. row .. " col " .. col)
          if grid.selected_tile ~= nil then
            if grid.selected_tile == index then
              grid.selected_tile = nil
            else
              local swap_tile = grid.selected_tile
              grid[index], grid[swap_tile] = grid[swap_tile], grid[index]
              grid.selected_tile = nil
            end
          else
            grid.selected_tile = index
          end
        end
      end
    end
  end
  --[[Cheatmode
  for i = 1, #grid.words do
    love.graphics.print(grid.words[i], 10, i * 20)
  end
  --]]

  shuffle_button.draw()
  random_button.draw()

  local sb = shuffle_button
  local rb = random_button
  local ib = increment_button
  local db = decrement_button
  local mx, my
  mx, my = love.mouse.getPosition()
  if point_in_rect(mx, my, ib.x, ib.y, ib.size, ib.size / 2) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", ib.x, ib.y, ib.size, ib.size / 2)
    increment_button.draw(1, 1, 1)
    if mouse.clicked then
      mouse.clicked = false
      local newgamesize = math.min(gamesize + 1, 6)
      if newgamesize ~= gamesize then
        gamesize = newgamesize
        game.init()
      end
    end
  else
    increment_button.draw(0, 0, 0)
  end

  if point_in_rect(mx, my, db.x, db.y, db.size, db.size / 2) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", db.x, db.y, db.size, db.size / 2)
    decrement_button.draw(1, 1, 1)
    if mouse.clicked then
      mouse.clicked = false
      local newgamesize = math.max(2, gamesize - 1)
      if newgamesize ~= gamesize then
        gamesize = newgamesize
        game.init()
      end
    end
  else
    decrement_button.draw(0, 0, 0)
  end

  local hb = hint_button

  if not hint_button_pressed then
    if point_in_rect(mx, my, hb.x, hb.y, hb.size, hb.size / 2) and not won_game then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("fill", hb.x, hb.y, hb.size, hb.size / 2)
      hint_button.draw(1, 1, 1)
      if mouse.clicked then
        mouse.clicked = false
        hint_button_pressed = true
      end
    else
      hint_button.draw(0, 0, 0)
    end
  else
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(get_hint(grid), hb.x - hb.size / 2 - 2, hb.y, hb.size * 2, "center")
  end

  local eb = exit_button

  if point_in_rect(mx, my, eb.x, eb.y, eb.size, eb.size / 2) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", eb.x, eb.y, eb.size, eb.size / 2)
    exit_button.draw(1, 1, 1)
    if mouse.clicked then
      mouse.clicked = false
      mouse.first_click = true
      gamestates.current_gamestate = "menu"
    end
  else
    exit_button.draw(0, 0, 0)
  end

  if mouse.clicked then
    if point_in_square(mouse.x, mouse.y, sb.x, sb.y, sb.size) then
      mouse.clicked = false
      start_shuffling(grid)
    elseif point_in_square(mouse.x, mouse.y, rb.x, rb.y, rb.size) then
      mouse.clicked = false
      start_randomizing(grid)
    end
  end
  --love.graphics.setColor(1, 0, 0)
  --love.graphics.rectangle("fill", ib.x, ib.y, ib.size, ib.size / 2)



  --[[local count_matching_rows = 0
  for row = 1, grid.rows do
    local word = ""
    for i = 1, grid.cols do
      word = word .. grid[row * grid.cols + i]
    end
    if wordlist_hash[word] ~= nil then
      count_matching_rows = count_matching_rows + 1
    end
  end
--]]
  if count_matching_rows == grid.rows then
    won_game = true
  else
    won_game = false
  end

  if won_game then
    love.graphics.setColor(0, 0, 0)
    draw_text("Y", 30, 110, 4)
    draw_text("O", 30, 170, 4)
    draw_text("U", 30, 230, 4)

    draw_text("W", 30, 310, 4)
    draw_text("I", 30, 370, 4)
    draw_text("N", 30, 430, 4)
  end
end

function game.resize(w, h)
end

function game.keypressed(key, scancode, isrepeat)
  --if scancode ~= "escape" then game.init() end
  if scancode == "r" then
    --game.init()
    start_randomizing(grid)
  elseif scancode == "s" then
    --We will allow shuffle to produce valid words by chance.
    start_shuffling(grid)
  elseif scancode == "-" then
    local newgamesize = math.max(2, gamesize - 1)
    if newgamesize ~= gamesize then
      gamesize = newgamesize
      game.init()
    end
  elseif scancode == "=" then
    --gamesize = math.min(gamesize + 1, 9)
    local newgamesize = math.min(gamesize + 1, 6)
    if newgamesize ~= gamesize then
      gamesize = newgamesize
      game.init()
    end
  elseif scancode == "h" then
    if not won_game then
      hint_button_pressed = true
    end
  elseif scancode == "escape" then
    gamestates.current_gamestate = "menu"
  end
end

function game.mousepressed(x, y, button, istouch, presses)
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
  --print("pressed")
end

function game.mousereleased(x, y, button, istouch, presses)
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
  --print("released")
end

return game
