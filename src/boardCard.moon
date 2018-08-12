lume = require("libs/lume")
log = _G.log

class BoardCard
  new: (actualCard) =>
    @cardBack = love.graphics.newImage("img/card_back.png")
    @actualCard = actualCard
    @triggered = false
    @revealed = false

    log.debug(string.format("Actual card is '%s'", @actualCard.name))

  draw: (x, y) =>
    love.graphics.setColor(1, 1, 1)

    if @revealed and not @triggered
      love.graphics.draw(@actualCard.sprite, x, y)
    elseif @triggered
      love.graphics.setColor(1, 1, 1, 0.1)
      love.graphics.draw(@actualCard.sprite, x, y)
    else
      love.graphics.draw(@cardBack, x, y)

return BoardCard