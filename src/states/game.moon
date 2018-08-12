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

    @map = require("map")(@cards)
    @player = require("player")!
    @background = love.graphics.newImage("img/background.png")

    @playerTurn = true

  draw: =>
    lovebite\startDraw!

    w, h = @background\getWidth!, @background\getHeight!
    for x = 0, lovebite.width / w
      for y = 0, lovebite.width / h
        love.graphics.draw(@background, x*w, y*h)

    @map\draw!
    @player\drawResources!

    @player\draw!

    lovebite\endDraw!

  update: (dt) =>
    controls\update(dt)

    @player\update(dt)

    if controls\released("quit")
      gsm\switch("mainMenu")

    if @playerTurn
      moved = false
      oldX, oldY = @player.x, @player.y

      if controls\pressed("left")
        @player.x -= 1
        moved = true
      elseif controls\pressed("right")
        @player.x += 1
        moved = true
      elseif controls\pressed("up")
        @player.y -= 1
        moved = true
      elseif controls\pressed("down")
        @player.y += 1
        moved = true

      if moved
        boardCard = @map.cards[@player.x] and @map.cards[@player.x][@player.y]

        if not boardCard
          log.debug(string.format("No card at player position %i, %i, moving back", @player.x, @player.y))

          @player.x = oldX
          @player.y = oldY
        elseif boardCard.triggered
          log.debug(string.format("Trying to move onto an already triggered card at %i, %i, moving back", @player.x, @player.y))

          @player.x = oldX
          @player.y = oldY
        else
          card = @map.cards[@player.x][@player.y]

          if card.actualCard.type == "effect"
            log.info("Stepped on an effect card")
            gsm\push("cardResolution", card, @map, @player)
          elseif card.actualCard.type == "equipment"
            log.info("Stepped on an equipment card")
            gsm\push("equipmentCardResolution", card, @map, @player)
          elseif card.actualCard.type == "combat"
            log.info("Stepped on an combat card")
            gsm\push("combatCardResolution", card, @map, @player)
          else
            log.error(string.format("Unknown card type '%s'!", card.actualCard.type))

  loadCards: =>
    cards = {}
    cardFiles = love.filesystem.getDirectoryItems("cards")

    for k, file in ipairs(cardFiles)
      if string.sub(file, -3) ~= "lua"
        log.trace("Rejecting card file"..file)
        continue

      f = string.format("cards/%s", file)\sub(1, -5)
      log.info(string.format("Loading card %s", f))

      table.insert(cards, require("card")(f))

    return cards

return Game