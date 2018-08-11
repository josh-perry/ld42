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

    @playerTurn = true

  draw: =>
    lovebite\startDraw!

    @map\draw!
    @player\drawResources(lovebite.width - 100, 0)

    @player\draw!

    lovebite\endDraw!

  update: (dt) =>
    controls\update(dt)

    if controls\released("quit")
      gsm\switch("mainMenu")

    if @playerTurn
      oldX, oldY = @player.x, @player.y

      if controls\pressed("left")
        @player.x -= 1
      if controls\pressed("right")
        @player.x += 1
      if controls\pressed("up")
        @player.y -= 1
      if controls\pressed("down")
        @player.y += 1

      if not @map.cards[@player.x] or not @map.cards[@player.x][@player.y]
        log.debug(string.format("No card at player position %i, %i, moving back", @player.x, @player.y))

        @player.x = oldX
        @player.y = oldY

return Game