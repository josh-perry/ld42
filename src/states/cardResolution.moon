lume = require("libs/lume")

local log
local lovebite
local gsm
local controls

class CardResolution
  init: =>
    controls = _G.controls
    gsm = _G.gamestateManager
    lovebite = _G.lovebite
    log = _G.log

    @background = love.graphics.newImage("img/background.png")

  enter: (previous, ...) =>
    @card, @map, @player = ...
    log.info(string.format("Resolving card '%s'", @card.actualCard.name))
    log.debug(string.format("There are %i effects", #@card.actualCard.effects))

    @effects = @card.actualCard.effects
    @menuItemIndex = 1

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

    for c, i in ipairs(@effects)
      if c == @menuItemIndex
        love.graphics.setColor(1, 1, 1)
      else
        love.graphics.setColor(0.4, 0.4, 0.4)

      y = ((lovebite.height/6)*4.5) + (c-1)*16
      love.graphics.printf(i.name, 0, y, lovebite.width, "center")

    lovebite\endDraw!

  update: (dt) =>
    controls\update(dt)

    if controls\pressed("up")
      _G.uiSound\play!
      @menuItemIndex -= 1

    if controls\pressed("down")
      _G.uiSound\play!
      @menuItemIndex += 1

    if controls\pressed("confirm")
      _G.uiConfirmSound\play!
      @card.triggered = true
      @card.actualCard.effects[@menuItemIndex].action(@player, @map)
      gsm\pop!
      @player\update(dt)

    @menuItemIndex = lume.clamp(@menuItemIndex, 1, #@effects)

  drawBigCard: =>
    love.graphics.setColor(1, 1, 1)
    x, y = lovebite.width/2, lovebite.height/2
    w, h = @card.actualCard.sprite\getWidth!, @card.actualCard.sprite\getHeight!
    s = 3, 3
    love.graphics.draw(@card.actualCard.sprite, x, y, 0, s, s, w/2, h/2)

    love.graphics.printf(@card.actualCard.name, 0, lovebite.height/6 - 4, lovebite.width, "center")

return CardResolution