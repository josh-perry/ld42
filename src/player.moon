lg = love.graphics

class Player
  new: =>
    @power = 100
    @wisdom = 50
    @agility = 10

  drawResources: (x, y) =>
    lg.setColor(0.2, 0.2, 0.2)
    lg.rectangle("fill", x, y, 100, 8*3)

    lg.setColor(1, 0.7, 0.7)
    lg.rectangle("fill", x, y, @power, 8)

    lg.setColor(0.7, 1, 0.7)
    lg.rectangle("fill", x, y + 8, @wisdom, 8)

    lg.setColor(0.7, 0.7, 1)
    lg.rectangle("fill", x, y + 16, @agility, 8)

return Player