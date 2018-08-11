lg = love.graphics

local log
local lovebite

class Player
  new: =>
    log = _G.log
    lovebite = _G.lovebite

    -- Stats
    @health = 5
    @power = 5
    @agility = 5
    @maxPower = 10
    @maxAgility = 10

    @barSize = 128

    -- Position
    @x = 4
    @y = 4

    @heartSprite = love.graphics.newImage("img/heart.png")

    log.info("Player initialized")

  draw: =>
    x = ((@x * 24) + @x * 8) - 8 + 12
    y = ((@y * 32) + @y * 8) - 8 + 16

    lg.setColor(0.4, 0.25, 0.5)
    lg.circle("fill", x, y, 12)

  drawResources: =>
    x, y = lovebite.width - 128, 0

    lg.setColor(1, 1, 1)

    for i = 1, @health
      offset = (i*8) + (i-1)
      love.graphics.draw(@heartSprite, lovebite.width - offset, y)

    lg.setColor(0.2, 0.2, 0.2)
    lg.rectangle("fill", x, y + 8, @barSize, 8*2)

    lg.setColor(1, 0.7, 0.7)
    lg.rectangle("fill", x, y + 8, (@power/@maxPower)*@barSize, 8)

    lg.setColor(0.7, 0.7, 1)
    lg.rectangle("fill", x, y + 16, (@agility/@maxAgility)*@barSize, 8)

return Player