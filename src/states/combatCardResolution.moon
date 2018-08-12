lume = require("libs/lume")
cron = require("libs/cron")

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

    @scale = 3

  enter: (previous, ...) =>
    @card, @map, @player = ...
    @deathSoundPlayed = false
    log.info(string.format("Resolving card '%s'", @card.actualCard.name))

    @playerTurn = true

    @menuItems = {}
    @menuItemIndex = 1

    @diceRollers = {}

    @makeMenus!

    @enemyHealth = @card.actualCard.stats.health

    @postDeathTimer = cron.after(2, () ->
      @card.triggered = true
      gsm\pop!)

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

    if @enemyHealth > 0
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
    if @player.health <= 0
      gsm\switch("gameOver")

    if @enemyHealth <= 0
      @scale = math.max(@scale - 2 * dt, 0)
    else
      @scale = (math.sin(love.timer.getTime()*5)/3) + 3

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
          love.audio.play(_G.hitSound)
      else
        diff = @diceRollers["enemy"].successes - @diceRollers["player"].successes

        log.info("Player taking "..diff.." damage")

        if diff > 0
          @player.health -= diff
          love.audio.play(_G.hitSound)

      @playerTurn = not @playerTurn
      @makeMenus!

      @diceRollers["player"] = nil
      @diceRollers["enemy"] = nil

    controls\update!

    if @enemyHealth <= 0
      @postDeathTimer\update(dt)

      if not @deathSoundPlayed
        _G.bossKillSound\play!
        @deathSoundPlayed = true
    else
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

  drawBigCard: =>
    love.graphics.setColor(1, 1, 1)
    x, y = lovebite.width/2, lovebite.height/2
    w, h = @card.actualCard.sprite\getWidth!, @card.actualCard.sprite\getHeight!
    love.graphics.draw(@card.actualCard.sprite, x, y, 0, @scale, @scale, w/2, h/2)

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
          @player.attackBuffed = false
          @player.defenseBuffed = false
          @menuItems = {}
      })

      if @player.attackPotions > 0 and not @player.attackBuffed
        table.insert(@menuItems, {
          name: "Quaff an attack potion",
          action: () ->
            @player.attackPotions -= 1
            @player.attackBuffed = true
            @menuItems = {}
            @makeMenus!
        })
    else
      table.insert(@menuItems, {
        name: "Roll your defense dice!",
        action: () ->
          @diceRollers["player"] = require("diceRoller")(@player\rollDefenseDice!, true, false, @player.successMin)
          @diceRollers["enemy"] = require("diceRoller")(rollDice(@card.actualCard.stats.attackDice), false, true, 4)
          @player.attackBuffed = false
          @player.defenseBuffed = false
          @menuItems = {}
      })

      if @player.defensePotions > 0 and not @player.defenseBuffed
        table.insert(@menuItems, {
          name: "Quaff a defense potion",
          action: () ->
            @player.defensePotions -= 1
            @player.defenseBuffed = true
            @menuItems = {}
            @makeMenus!
        })

return CombatCardResolution