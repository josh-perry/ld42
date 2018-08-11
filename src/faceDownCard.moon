log = _G.log

class FaceDownCard
  new: (actualCard) =>
    @sprite = love.graphics.newImage("img/card_back.png")
    @actualCard = actualCard

    log.debug(string.format("Actual card is '%s'", @actualCard.name))

  draw: (x, y) =>
    love.graphics.draw(@sprite, x, y)

return FaceDownCard