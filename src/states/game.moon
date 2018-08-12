lume = require("libs/lume")
cron = require("libs/cron")
flux = require("libs/flux")

local lovebite
local log
local gsm
local controls

lg = love.graphics

class Game
  init: =>
    log = _G.log
    lovebite = _G.lovebite
    gsm = _G.gamestateManager
    controls = _G.controls

    @cards = @loadCards!
    @player = require("player")!
    @background = love.graphics.newImage("img/background.png")

    @level = 0

  enter: =>
    @reloadMap!

  reloadMap: =>
    @level += 1
    @map = require("map")(@cards, @level)
    @player\resetPosition!

    @playerTurn = true
    @bossTimer = cron.after(2, () ->
      if @map.cards[@player.gridX][@player.gridY].actualCard.type == "boss"
        print("boss already killed")
        @reloadMap!
      else
        @map.cards[@player.gridX][@player.gridY] = require("boardCard")(@map.bossCard)
        gsm\push("combatCardResolution", @map.cards[@player.gridX][@player.gridY], @map, @player)
        @bossTimer\reset!)

  draw: =>
    lovebite\startDraw!

    w, h = @background\getWidth!, @background\getHeight!
    for x = 0, lovebite.width / w
      for y = 0, lovebite.width / h
        love.graphics.draw(@background, x*w, y*h)

    @map\draw!
    @player\drawResources!

    @player\draw!

    love.graphics.print(@getMoveCount!, 10, 10)

    lovebite\endDraw!

  getMoveCount: =>
    moves = 0

    directions = {
      {x: -1, y: 0},
      {x: 1, y: 0},
      {x: 0, y: -1},
      {x: 0, y: 1}
    }

    for _, o in ipairs(directions)
      boardCard = @map.cards[@player.gridX - o.x] and @map.cards[@player.gridX - o.x][@player.gridY + o.y]

      if boardCard and not boardCard.triggered
        moves += 1

    return moves

  update: (dt) =>
    flux.update(dt)
    controls\update(dt)

    if @getMoveCount! <= 0
      @bossTimer\update(dt)

    @player\update(dt)

    if controls\released("quit")
      gsm\switch("mainMenu")

    if @playerTurn
      moved = false
      oldX, oldY = @player.gridX, @player.gridY

      if controls\pressed("left")
        @player.gridX -= 1
        moved = true
      elseif controls\pressed("right")
        @player.gridX += 1
        moved = true
      elseif controls\pressed("up")
        @player.gridY -= 1
        moved = true
      elseif controls\pressed("down")
        @player.gridY += 1
        moved = true

      if moved
        boardCard = @map.cards[@player.gridX] and @map.cards[@player.gridX][@player.gridY]

        if not boardCard
          log.debug(string.format("No card at player position %i, %i, moving back", @player.gridX, @player.gridY))

          @player.gridX = oldX
          @player.gridY = oldY
        elseif boardCard.triggered
          log.debug(string.format("Trying to move onto an already triggered card at %i, %i, moving back", @player.gridX, @player.gridY))

          @player.gridX = oldX
          @player.gridY = oldY
        else
          love.audio.play(_G.moveSound)

          pX = ((@player.gridX * 24) + @player.gridX * 8) - 8
          pY = ((@player.gridY * 32) + @player.gridY * 8) - 8 - 12

          @playerTurn = false

          flux.to(@player, .8, {x: pX, y: pY})\ease("elasticout")\oncomplete(() ->
            @triggerCard!
            @playerTurn = true)

  triggerCard: =>
    card = @map.cards[@player.gridX][@player.gridY]

    while true
      s = lume.randomchoice(_G.cardSounds)

      if not s\isPlaying!
        s\play!
        break

    if card.actualCard.type == "effect"
      log.info("Stepped on an effect card")
      gsm\push("cardResolution", card, @map, @player)
    elseif card.actualCard.type == "equipment"
      log.info("Stepped on an equipment card")
      gsm\push("equipmentCardResolution", card, @map, @player)
    elseif card.actualCard.type == "combat" or card.actualCard.type == "boss"
      log.info("Stepped on an combat card")
      gsm\push("combatCardResolution", card, @map, @player)
    else
      log.error(string.format("Unknown card type '%s'!", card.actualCard.type))

  loadCards: =>
    cards = {}
    cardFiles = love.filesystem.getDirectoryItems("cards")

    effects = 0
    combat = 0
    equipment = 0

    for k, file in ipairs(cardFiles)
      if string.sub(file, -3) ~= "lua"
        log.trace("Rejecting card file"..file)
        continue

      f = string.format("cards/%s", file)\sub(1, -5)
      log.info(string.format("Loading card %s", f))

      c = require("card")(f)
      table.insert(cards, c)

      if c.type == "effect"
        effects += 1
      elseif c.type == "combat"
        combat += 1
      elseif c.type == "equipment"
        equipment += 1

    log.debug(string.format("Loaded %i effect cards", effects))
    log.debug(string.format("Loaded %i combat cards", combat))
    log.debug(string.format("Loaded %i equipment cards", equipment))
    log.debug(string.format("Loaded %i total cards", effects+combat+equipment))

    return cards

return Game