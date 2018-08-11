class FaceDownCard
  new: =>
    @sprite = love.graphics.newImage("img/card_back.png")

  draw: (x, y) =>
    love.graphics.draw(@sprite, x, y)

return FaceDownCard