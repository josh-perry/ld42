local gsm
local controls

class CardResolution
  init: =>
    controls = _G.controls
    gsm = _G.gamestateManager

  enter: (previous, ...) =>
    @card, @map, @player = ...

  draw: =>
    lovebite\startDraw!

    @map\draw!
    @player\drawResources(lovebite.width - 100, 0)

    @player\draw!

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(@card.actualCard.sprite, 0, 0)

    lovebite\endDraw!

  update: (dt) =>
    controls\update(dt)

    if controls\pressed("confirm")
      @card\resolve(@player)
      gsm\pop!

return CardResolution