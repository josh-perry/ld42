local lovebite
local gsm
local controls

class CardResolution
  init: =>
    controls = _G.controls
    gsm = _G.gamestateManager
    lovebite = _G.lovebite

  enter: (previous, ...) =>
    @card, @map, @player = ...

  draw: =>
    lovebite\startDraw!

    @map\draw!
    @player\drawResources(lovebite.width - 100, 0)

    @player\draw!

    @drawBigCard!

    lovebite\endDraw!

  update: (dt) =>
    controls\update(dt)

    if controls\pressed("confirm")
      @card\resolve(@player)
      gsm\pop!

  drawBigCard: =>
    love.graphics.setColor(1, 1, 1)
    x, y = lovebite.width/2, lovebite.height/2
    w, h = @card.actualCard.sprite\getWidth!, @card.actualCard.sprite\getHeight!
    s = 4, 4
    love.graphics.draw(@card.actualCard.sprite, x, y, 0, s, s, w/2, h/2)

    love.graphics.printf(@card.actualCard.name, 0, lovebite.height/6 - 4, lovebite.width, "center")

return CardResolution