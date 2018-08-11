lume = require("libs/lume")

local log
local lovebite
local gsm
local controls

lg = love.graphics

class CombatCardResolution
  init: =>
    controls = _G.controls
    gsm = _G.gamestateManager
    lovebite = _G.lovebite
    log = _G.log

    @background = love.graphics.newImage("img/background.png")

  enter: (previous, ...) =>
    @card, @map, @player = ...
    log.info(string.format("Resolving card '%s'", @card.actualCard.name))

  draw: =>
    lovebite\startDraw!

    w, h = @background\getWidth!, @background\getHeight!
    for x = 0, lovebite.width / w
      for y = 0, lovebite.width / h
        love.graphics.draw(@background, x*w, y*h)

    @map\draw!

    @player\draw!

    love.graphics.setColor(0.01, 0.01, 0.01, 0.9)
    love.graphics.rectangle("fill", 80, 0, lovebite.width-160, lovebite.height)

    @player\drawResources!

    @drawBigCard!

    lovebite\endDraw!

  update: (dt) =>
    controls\update!

  drawBigCard: =>
    love.graphics.setColor(1, 1, 1)
    x, y = lovebite.width/2, lovebite.height/2
    w, h = @card.actualCard.sprite\getWidth!, @card.actualCard.sprite\getHeight!
    s = 3, 3
    love.graphics.draw(@card.actualCard.sprite, x, y, 0, s, s, w/2, h/2)

    love.graphics.printf(@card.actualCard.name, 0, lovebite.height/6 - 4, lovebite.width, "center")


return CombatCardResolution