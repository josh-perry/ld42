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
    @maxPower = 20
    @maxAgility = 20

    @attackDice = 0
    @defenseDice = 0

    @successMin = 4

    @equipment = {}

    @barSize = 64

    @attackPotions = 2
    @defensePotions = 2

    @resetPosition!

    @sprite = love.graphics.newImage("img/player.png")

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

  resetPosition: =>
    -- Position
    @gridX = 3
    @gridY = 3

    @x = ((@gridX * 24) + @gridX * 8) - 8
    @y = ((@gridY * 32) + @gridY * 8) - 8 - 12

  update: (dt) =>
    @health = lume.clamp(@health, 0, @maxHealth)
    @power = lume.clamp(@power, 0, @maxPower)
    @agility = lume.clamp(@agility, 0, @maxAgility)

    @calculateDice!
    @calculateBuffs!

  calculateBuffs: =>
    @successMin = 4

    for _, v in ipairs(@equipment)
      @successMin += v.successMin

  draw: =>
    lg.draw(@sprite, @x, @y)

    @drawEquipment!

  drawEquipment: =>
    lg.setColor(1, 1, 1)

    for i, v in ipairs(@equipment)
      love.graphics.draw(v.sprite, lovebite.width - 32 - ((i-1) * 12) + i, 128)

  drawResources: =>
    x, y = lovebite.width - @barSize, 0

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
    lg.printf("Attack dice: "..@attackDice, lovebite.width - 100, 64 - 2, 96, "right")
    lg.printf("Defense dice: "..@defenseDice, lovebite.width - 100, 80 - 2, 96, "right")

    lg.setColor(1, 1, 1)
    lg.printf("Attack potions: "..@attackPotions, lovebite.width - 100, 96 - 2, 96, "right")
    lg.printf("Defense potions: "..@defensePotions, lovebite.width - 100, 112 - 2, 96, "right")

  calculateDice: =>
    @calculateAttackDice!
    @calculateDefenseDice!

  calculateAttackDice: =>
    dice = math.floor(@power/2)

    log.trace(string.format("%i attack dice from base stats", dice))

    for _, v in ipairs(@equipment)
      if not v.diceBoosts
        continue

      log.trace(string.format("+%i attack dice from equipped %s", v.diceBoosts.attack, v.name))

      dice += v.diceBoosts.attack or 0

    log.trace(string.format("%i total attack dice", dice))
    @attackDice = dice

  calculateDefenseDice: =>
    dice = math.floor(@agility/2)

    log.trace(string.format("%i defense dice from base stats", dice))

    for _, v in ipairs(@equipment)
      if not v.diceBoosts
        continue

      dice += v.diceBoosts.defense or 0
      log.trace(string.format("+%i defense dice from equipped %s", v.diceBoosts.defense, v.name))

    log.trace(string.format("%i total attack dice", dice))
    @defenseDice = dice

  rollAttackDice: =>
    rolls = {}

    diceCount = @attackDice

    if @attackBuffed
      diceCount += 4

    for i = 1, diceCount
      rolls[i] = love.math.random(1, 6)
      log.debug(string.format("Rolled a %i on attack", rolls[i]))

    return rolls

  rollDefenseDice: =>
    rolls = {}

    diceCount = @defenseDice

    if @defenseBuffed
      diceCount += 4

    for i = 1, diceCount
      rolls[i] = love.math.random(1, 6)
      log.debug(string.format("Rolled a %i on defense", rolls[i]))

    return rolls

return Player