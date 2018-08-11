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

  resolve: (player) =>
    if not @faceDown
      return

    @faceDown = false

    -- if #@actualCard.effects == 1
    @actualCard.effects[1].action(player)
    -- else
    -- lume.randomchoice(@actualCard.effects).action(player)

return BoardCard