sti = require("libs.sti")

local lovebite
local log
local gsm
local controls

lg = love.graphics

class Game
  init: =>
    log = _G.log
    lovebite = _G.lovebite
    gsm = _G.gamestateManager
    controls = _G.controls

    @map = sti("maps/entrance.lua")

  draw: =>
    lovebite\startDraw!

    @map\draw!

    lovebite\endDraw!

  update: (dt) =>
    controls\update(dt)
    @map\update(dt)

    if controls\pressed("quit")
      gsm\switch("mainMenu")

return Game