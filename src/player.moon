lg = love.graphics

local log

class Player
  new: =>
    log = _G.log

    -- Resources
    @power = 100
    @wisdom = 50
    @agility = 10

    -- Position
    @x = 4
    @y = 4

    log.info("Player initialized")

  draw: =>
    x = ((@x * 24) + @x * 8) - 8 + 12
    y = ((@y * 32) + @y * 8) - 8 + 16

    lg.setColor(0.4, 0.25, 0.5)
    lg.circle("fill", x, y, 12)

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