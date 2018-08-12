lume = require("libs/lume")

local log
local lovebite
local gsm
local controls

lg = love.graphics

rollDice = (diceCount) ->
  r = {}

  for i = 1, diceCount
    r[i] = love.math.random(1, 6)

  return r

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

    @enemyHealth = @card.actualCard.stats.health

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

    lg.setColor(1, 1, 1)
    if @playerTurn
      lg.printf("Attacking", 10, lovebite.height - 10, lovebite.height - 20, "left", -1.5708)
      lg.printf("Defending", 10, lovebite.height - 10, lovebite.height - 20, "right", -1.5708)
    else
      lg.printf("Defending", 10, lovebite.height - 10, lovebite.height - 20, "left", -1.5708)
      lg.printf("Attacking", 10, lovebite.height - 10, lovebite.height - 20, "right", -1.5708)

    lovebite\endDraw!

  update: (dt) =>
    allRollersDone = true
    for i, v in pairs(@diceRollers)
      v\update(dt)

      if not v.done
        allRollersDone = false

    if allRollersDone and @diceRollers["player"] and @diceRollers["enemy"]
      if @playerTurn
        diff = @diceRollers["player"].successes - @diceRollers["enemy"].successes

        log.info("Enemy taking "..diff.." damage")

        if diff > 0
          @enemyHealth -= diff
      else
        diff = @diceRollers["enemy"].successes - @diceRollers["player"].successes

        log.info("Player taking "..diff.." damage")

        if diff > 0
          @player.health -= diff

      @playerTurn = not @playerTurn
      @makeMenus!

      @diceRollers["player"] = nil
      @diceRollers["enemy"] = nil

    controls\update!

    if controls\pressed("confirm")
      menuItem = @menuItems[@menuItemIndex]

      if menuItem and menuItem.action
        _G.uiConfirmSound\play!
        menuItem.action!

    if controls\pressed("up")
      _G.uiSound\play!
      @menuItemIndex -= 1

    if controls\pressed("down")
      _G.uiSound\play!
      @menuItemIndex += 1

    @menuItemIndex = lume.clamp(@menuItemIndex, 1, #@menuItems)

    if @enemyHealth <= 0
      @card.triggered = true
      gsm\pop!

  drawBigCard: =>
    love.graphics.setColor(1, 1, 1)
    x, y = lovebite.width/2, lovebite.height/2
    w, h = @card.actualCard.sprite\getWidth!, @card.actualCard.sprite\getHeight!
    s = 3, 3
    love.graphics.draw(@card.actualCard.sprite, x, y, 0, s, s, w/2, h/2)

    love.graphics.printf(@card.actualCard.name, 0, lovebite.height/6 - 4, lovebite.width, "center")

    xOffset = (lovebite.width / 2) - ((@enemyHealth * 9) / 2)

    for i = 1, @enemyHealth
      offset = (i*8) + (i-1)
      love.graphics.draw(@heartSprite, xOffset + offset, lovebite.height / 6 + 16, 0, 1, 1, 4, 4)

  makeMenus: =>
    if @playerTurn
      table.insert(@menuItems, {
        name: "Roll your attack dice!",
        action: () ->
          @diceRollers["player"] = require("diceRoller")(@player\rollAttackDice!, true, true, @player.successMin)
          @diceRollers["enemy"] = require("diceRoller")(rollDice(@card.actualCard.stats.defenseDice), false, false, 4)
          @menuItems = {}
      })
    else
      table.insert(@menuItems, {
        name: "Roll your defense dice!",
        action: () ->
          @diceRollers["player"] = require("diceRoller")(@player\rollDefenseDice!, true, false, @player.successMin)
          @diceRollers["enemy"] = require("diceRoller")(rollDice(@card.actualCard.stats.attackDice), false, true, 4)
          @menuItems = {}
      })

return CombatCardResolution