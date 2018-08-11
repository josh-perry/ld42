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
      love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
      love.graphics.rectangle("fill", x, y, 24, 32)
      love.graphics.draw(@cardBack, x, y)

  resolve: (player) =>
    if not @faceDown
      return

    @faceDown = false
    @actualCard\effect(player)

return BoardCard