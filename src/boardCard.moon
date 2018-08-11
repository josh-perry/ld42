lume = require("libs/lume")
log = _G.log

class BoardCard
  new: (actualCard) =>
    @cardBack = love.graphics.newImage("img/card_back.png")
    @actualCard = actualCard
    @faceDown = true

    log.debug(string.format("Actual card is '%s'", @actualCard.name))

  draw: (x, y) =>
    love.graphics.setColor(1, 1, 1)

    if @faceDown
      love.graphics.draw(@cardBack, x, y)
    else
      love.graphics.draw(@actualCard.sprite, x, y)

return BoardCard