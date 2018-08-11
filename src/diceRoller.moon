lovebite = _G.lovebite

cron = require("libs/cron")
lume = require("libs/lume")
flux = require("libs/flux")

class Dice
  new: (result, sprite, quads, bottom) =>
    @bottom = bottom
    @result = result
    @sprite = sprite
    @quads = quads

    @x = love.math.random(50, lovebite.width-50)

    @rotation = 0
    @rotationSpeed = love.math.random(-10, 10)

    @scale = 1.5
    @velScale = 0

    @velX = love.math.random(-20, 20)

    if @bottom
      @y = lovebite.height + 16
      @velY = love.math.random(-300, -600)
    else
      @y = -16
      @velY = love.math.random(300, 600)

    @settled = false

    @settleTimer = cron.after(love.math.random(1, 3), () -> @settled = true)

  draw: =>
    local result

    if @settled
      result = @result

      if result < 4
        @velScale = -4
    else
      result = love.math.random(1, 6)

    w, h = 16, 16
    love.graphics.draw(@sprite, @quads[result], @x, @y, @rotation, @scale, @scale, w/2, h/2)

  update: (dt) =>
    @settleTimer\update(dt)

    @scale = math.max(@scale + @velScale * dt, 0)

    if not @settled
      @x += @velX * dt
      @y += @velY * dt
      @rotation += @rotationSpeed * dt

      if @bottom
        if @y < (lovebite.height/2) + 16 and @velY < 0
          @velY -= (@velY * 1.5)
          @extraBarrier = true
        elseif @extraBarrier and @y > lovebite.height - 16 and @velY > 0
          @velY -= (@velY * 1.5)
      else
        if @y > (lovebite.height/2) - 16 and @velY > 0
          @velY -= (@velY * 1.5)
          @extraBarrier = true
        elseif @extraBarrier and @y < 16 and @velY < 0
          @velY -= (@velY * 1.5)

class DiceRoller
  new: (results, bottom, attacking) =>
    local diceSprite

    @attacking = attacking
    @successes = 0

    for _, r in ipairs(results)
      if r >= 4
        @successes += 1

    @bottom = bottom

    if @bottom
      diceSprite = love.graphics.newImage("img/dice.png")
    else
      diceSprite = love.graphics.newImage("img/evil dice.png")

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
      table.insert(@dice, Dice(r, diceSprite, diceQuads, @bottom))

  draw: =>
    for _, d in ipairs(@dice)
      d\draw!

  reportDone: =>
    @done = true
    log.info(string.format("Rolling done: %i successes", @successes))

  update: (dt) =>
    flux.update(dt)

    if @allSettled
      if @postSettledTimer
        @postSettledTimer\update(dt)

    @allSettled = true

    for _, d in ipairs(@dice)
      d\update(dt)

      if not d.settled
        @allSettled = false

    if @allSettled and not @postSettledTimer
      y = (lovebite.height / 6)
      y2 = (lovebite.height / 6) * 5 + 16

      if @bottom
        y = (lovebite.height / 6) * 5
        y2 = lovebite.height / 6 + 16

      xOffset = (lovebite.width / 2) - ((@successes * 33) / 2)

      i = 0
      for _, d in ipairs(@dice)
        if d.result >= 4
          i += 1
          flux.to(d, 1, {x: xOffset + (i*32) + (i-1) - 16, y: y - 16})\oncomplete(() ->
            d.rotation = 0

            if @attacking
              flux.to(d, 1, {x: lovebite.width/2, y: y2}))

      @postSettledTimer = cron.after(1, () -> @reportDone!)

return DiceRoller