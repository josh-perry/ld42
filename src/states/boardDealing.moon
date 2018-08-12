lume = require("libs/lume")
cron = require("libs/cron")
flux = require("libs/flux")

local lovebite
local log
local gsm
local controls

class FlyingCard
  new: =>
    @x = lovebite.width / 2
    @y = lovebite.height + 16

class BoardDealing
  init: =>
    log = _G.log
    lovebite = _G.lovebite
    gsm = _G.gamestateManager
    controls = _G.controls

    @background = love.graphics.newImage("img/background.png")
    @cardBack = love.graphics.newImage("img/card_back.png")

    @sounds = _G.cardSounds

  playSound: =>
    while true
      s = lume.randomchoice(@sounds)

      if not s\isPlaying!
        s\play!
        break

  enter: =>
    @mapX = 5
    @mapY = 5

    @cards = {}

    @group = flux.group()

    @postDoneTimer = cron.after(0.5, () -> gsm\switch("game"))

    i = 0
    @totalCards = 0
    @doneCards = 0

    for x = 1, @mapX
      @cards[x] = {}

      for y = 1, @mapY
        if x == 1 and y == 1 or x == 1 and y == @mapY or x == @mapX and y == 1 or x == @mapX and y == @mapY or x == 3 and y == 3
           continue

        i += 1

        card = FlyingCard!
        @cards[x][y] = card

        toX = ((x * 24) + x * 8) - 8
        toY = ((y * 32) + y * 8) - 8

        @group\to(card, 1, {x: toX, y: toY})\delay(i/8)\oncomplete(() ->
          @doneCards += 1
          @playSound!)

    @totalCards = i

  draw: =>
    lovebite\startDraw!

    w, h = @background\getWidth!, @background\getHeight!
    for x = 0, lovebite.width / w
      for y = 0, lovebite.width / h
        love.graphics.draw(@background, x*w, y*h)

    for x = 1, @mapX
      for y = 1, @mapY
        c = @cards[x][y]

        if c
          love.graphics.draw(@cardBack, c.x, c.y)

    lovebite\endDraw!

  update: (dt) =>
    @group\update(dt)

    if @doneCards >= @totalCards
      @postDoneTimer\update(dt)

return BoardDealing