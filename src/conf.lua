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
--See https://love2d.org/wiki/Config_Files for reference.
function love.conf(t)
  t.identity = "com.maniksinha"
  --t.window.title = "Words by Manik Sinha"
  t.window.title = "Words"
  t.window.resizable = false
  t.window_width = 800
  t.window_height = 600
  --[[
  t.window.resizable = true
  t.window.minwidth = 100
  t.window.minheight = 100
  --]]
  --t.window.highdpi = true
  --t.window.vsync = true
end
