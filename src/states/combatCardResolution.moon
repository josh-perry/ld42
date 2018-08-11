lume = require("libs/lume")

local log
local lovebite
local gsm
local controls

lg = love.graphics

class CombatCardResolution
  init: =>
    controls = _G.controls
    gsm = _G.gamestateManager
    lovebite = _G.lovebite
    log = _G.log

    @background = love.graphics.newImage("img/background.png")
    @heartSprite = love.graphics.newImage("img/heart.png")

  enter: (previous, ...) =>
    @card, @map, @player = ...
    log.info(string.format("Resolving card '%s'", @card.actualCard.name))

    @playerTurn = true

    @menuItems = {}
    @menuItemIndex = 1

    @diceRollers = {}

    @makeMenus!

  draw: =>
    lovebite\startDraw!

    w, h = @background\getWidth!, @background\getHeight!
    for x = 0, lovebite.width / w
      for y = 0, lovebite.width / h
        love.graphics.draw(@background, x*w, y*h)

    @map\draw!

    @player\draw!

    love.graphics.setColor(0.01, 0.01, 0.01, 0.9)
    love.graphics.rectangle("fill", 80, 0, lovebite.width-160, lovebite.height)

    @player\drawResources!

    @drawBigCard!

    for i, v in pairs(@diceRollers)
      v\draw!

    for c, i in ipairs(@menuItems)
      if c == @menuItemIndex
        lg.setColor(1, 1, 1)
      elseif i.action
        lg.setColor(0.4, 0.4, 0.4)
      else
        lg.setColor(0.1, 0.1, 0.1)

      y = ((lovebite.height/6)*4.5) + (c-1)*16
      lg.printf(i.name, 0, y, lovebite.width, "center")

    lovebite\endDraw!

  update: (dt) =>
    allRollersDone = true
    for i, v in pairs(@diceRollers)
      v\update(dt)

      if not v.done
        allRollersDone = false

    if allRollersDone and @diceRollers["player"] and @diceRollers["enemy"]
      @playerTurn = not @playerTurn
      @makeMenus!

      @diceRollers["player"] = nil
      @diceRollers["enemy"] = nil

    controls\update!

    if controls\pressed("confirm")
      menuItem = @menuItems[@menuItemIndex]

      if menuItem and menuItem.action
        menuItem.action!

    if controls\pressed("up")
      @menuItemIndex -= 1

    if controls\pressed("down")
      @menuItemIndex += 1

    @menuItemIndex = lume.clamp(@menuItemIndex, 1, #@menuItems)

  drawBigCard: =>
    love.graphics.setColor(1, 1, 1)
    x, y = lovebite.width/2, lovebite.height/2
    w, h = @card.actualCard.sprite\getWidth!, @card.actualCard.sprite\getHeight!
    s = 3, 3
    love.graphics.draw(@card.actualCard.sprite, x, y, 0, s, s, w/2, h/2)

    love.graphics.printf(@card.actualCard.name, 0, lovebite.height/6 - 4, lovebite.width, "center")

    xOffset = (lovebite.width / 2) - ((@card.actualCard.stats.health * 9) / 2)

    for i = 1, @card.actualCard.stats.health
      offset = (i*8) + (i-1)
      love.graphics.draw(@heartSprite, xOffset + offset, lovebite.height / 6 + 16, 0, 1, 1, 4, 4)

  makeMenus: =>
    if @playerTurn
      table.insert(@menuItems, {
        name: "Roll your attack dice!",
        action: () ->
          @diceRollers["player"] = require("diceRoller")(@player\rollAttackDice!, true)
          @diceRollers["enemy"] = require("diceRoller")(@player\rollAttackDice!, false)
          @menuItems = {}
      })
    else
      table.insert(@menuItems, {
        name: "Roll your defense dice!",
        action: () ->
          @diceRollers["player"] = require("diceRoller")(@player\rollDefenseDice!, true)
          @diceRollers["enemy"] = require("diceRoller")(@player\rollAttackDice!, false)
          @menuItems = {}
      })

return CombatCardResolution