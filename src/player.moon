lg = love.graphics

lume = require("libs/lume")

local log
local lovebite

class Player
  new: =>
    log = _G.log
    lovebite = _G.lovebite

    -- Stats
    @health = 5
    @power = 6
    @agility = 6
    @maxHealth = 10
    @maxPower = 10
    @maxAgility = 10

    @attackDice = 0
    @defenseDice = 0

    @equipment = {}

    @barSize = 128

    -- Position
    @x = 4
    @y = 4

    @heartSprite = love.graphics.newImage("img/heart.png")

    @diceSprite = love.graphics.newImage("img/dice.png")

    w, h = @diceSprite\getWidth!, @diceSprite\getHeight!
    @diceQuads = {
        love.graphics.newQuad(0, 0, 16, 16, w, h),
        love.graphics.newQuad(16, 0, 16, 16, w, h),
        love.graphics.newQuad(32, 0, 16, 16, w, h),
        love.graphics.newQuad(48, 0, 16, 16, w, h),
        love.graphics.newQuad(64, 0, 16, 16, w, h),
        love.graphics.newQuad(80, 0, 16, 16, w, h)
    }

    @calculateDice!

    log.info("Player initialized")

  update: (dt) =>
    @health = lume.clamp(@health, 0, @maxHealth)
    @power = lume.clamp(@power, 0, @maxPower)
    @agility = lume.clamp(@agility, 0, @maxAgility)

    @calculateDice!

  draw: =>
    x = ((@x * 24) + @x * 8) - 8 + 12
    y = ((@y * 32) + @y * 8) - 8 + 16

    lg.setColor(0.4, 0.25, 0.5)
    lg.circle("fill", x, y, 12)

    @drawEquipment!

  drawEquipment: =>
    lg.setColor(1, 1, 1)

    for i, v in ipairs(@equipment)
      love.graphics.draw(v.sprite, lovebite.width - 32 - ((i-1) * 12) + i, 128)

  drawResources: =>
    x, y = lovebite.width - 128, 0

    lg.setColor(1, 1, 1)

    for i = 1, @health
      offset = (i*8) + (i-1)
      love.graphics.draw(@heartSprite, lovebite.width - offset, y + 2)

    lg.setColor(0.2, 0.2, 0.2)
    lg.rectangle("fill", x, y + 12, @barSize, 12*2)

    lg.setColor(1, 0.7, 0.7)
    lg.rectangle("fill", x, y + 12, (@power/@maxPower)*@barSize, 12)

    lg.setColor(1, 1, 1)
    lg.printf(@power, x - 100, y + 12 - 4, 96, "right")

    lg.setColor(0.7, 0.7, 1)
    lg.rectangle("fill", x, y + 24, (@agility/@maxAgility)*@barSize, 12)

    lg.setColor(1, 1, 1)
    lg.printf(@agility, x - 100, y + 24 - 4, 96, "right")

    lg.setColor(1, 1, 1)
    lg.printf("Attack dice", lovebite.width - 24 - 100, 64 - 2, 96, "right")
    lg.printf("Defense dice", lovebite.width - 24 - 100, 80 - 2, 96, "right")

    lg.draw(@diceSprite, @diceQuads[@attackDice], lovebite.width - 24, 64)
    lg.draw(@diceSprite, @diceQuads[@defenseDice], lovebite.width - 24, 80)

  calculateDice: =>
    @calculateAttackDice!
    @calculateDefenseDice!

  calculateAttackDice: =>
    dice = lume.clamp(math.floor(@power/2), 1, 6)

    log.trace(string.format("%i attack dice from base stats", dice))

    for _, v in ipairs(@equipment)
      if not v.diceBoosts
        continue

      log.trace(string.format("+%i attack dice from equipped %s", v.diceBoosts.attack, v.name))

      dice += v.diceBoosts.attack or 0

    log.trace(string.format("%i total attack dice", dice))
    @attackDice = dice

  calculateDefenseDice: =>
    dice = lume.clamp(math.floor(@agility/2), 1, 6)

    log.trace(string.format("%i defense dice from base stats", dice))

    for _, v in ipairs(@equipment)
      if not v.diceBoosts
        continue

      dice += v.diceBoosts.defense or 0
      log.trace(string.format("+%i defense dice from equipped %s", v.diceBoosts.defense, v.name))

    log.trace(string.format("%i total attack dice", dice))
    @defenseDice = dice

return Player