lovebite = _G.lovebite

cron = require("libs/cron")

class Dice
  new: (result, sprite, quads) =>
    @result = result
    @sprite = sprite
    @quads = quads

    @x = love.math.random(50, lovebite.width-50)
    @y = lovebite.height + 16

    @velX = love.math.random(-20, 20)
    @velY = love.math.random(-200, -300)

    @settled = false

    @settleTimer = cron.after(love.math.random(0.5, 1.5), () -> @settled = true)

  draw: =>
    local result

    if @settled
      result = @result

      if result >= 5
        love.graphics.setColor(0, 1, 0)
      else
        love.graphics.setColor(1, 0, 0)
    else
      result = love.math.random(1, 6)

    love.graphics.draw(@sprite, @quads[result], @x, @y)

  update: (dt) =>
    @settleTimer\update(dt)

    if not @settled
      @x += @velX * dt
      @y += @velY * dt

      if @y < 16 and @velY < 0
        @velY -= (@velY * 1.5)

class DiceRoller
  new: (results) =>
    diceSprite = love.graphics.newImage("img/dice.png")

    w, h = diceSprite\getWidth!, diceSprite\getHeight!
    diceQuads = {
        love.graphics.newQuad(0, 0, 16, 16, w, h),
        love.graphics.newQuad(16, 0, 16, 16, w, h),
        love.graphics.newQuad(32, 0, 16, 16, w, h),
        love.graphics.newQuad(48, 0, 16, 16, w, h),
        love.graphics.newQuad(64, 0, 16, 16, w, h),
        love.graphics.newQuad(80, 0, 16, 16, w, h)
    }

    @results = results

    @dice = {}

    for _, r in ipairs(results)
      table.insert(@dice, Dice(r, diceSprite, diceQuads))

  draw: =>
    for _, d in ipairs(@dice)
      d\draw!

  update: (dt) =>
    for _, d in ipairs(@dice)
      d\update(dt)

return DiceRoller