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

    @cardBackSprite = love.graphics.newImage("img/card_back.png")

    @map = require("map")!
    @player = require("player")!

  draw: =>
    lovebite\startDraw!

    @map\draw!
    @player\drawResources(lovebite.width - 100, 0)

    lovebite\endDraw!

  update: (dt) =>
    controls\update(dt)

    if controls\pressed("quit")
      gsm\switch("mainMenu")

return Game