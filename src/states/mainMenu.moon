lume = require("libs/lume")

log = _G.log
lg = love.graphics

local lovebite
local controls
local fullscreen

class MainMenu
  init: =>
    lovebite = _G.lovebite
    gsm = _G.gamestateManager
    controls = _G.controls

    fullscreen = false

    @font = lg.newFont("fonts/Pixel-UniCode.fnt")

    @menuItems = {
      {
        display: "New Game",
        action: () -> gsm\switch("boardDealing")
      },
      {
        display: "Continue"
      },
      {
        display: "Toggle Fullscreen",
        action: () ->
          fullscreen = not fullscreen

          if fullscreen
            lovebite\setMode({
              width: 320,
              height: 240,
              scale: 0,
              flags: {
                fullscreen: true,
                fullscreentype: "desktop",
                vsync: false
              }
            })
          else
            lovebite\setMode({
              width: 320,
              height: 240,
              scale: 3,
              flags: {
                vsync: false
              }
            })
      },
      {
        display: "Quit",
        action: () -> love.event.quit!
      }
    }

    @menuItemIndex = 1

  draw: =>
    lovebite\startDraw!

    lg.setFont(@font)

    for c, i in ipairs(@menuItems)
      if c == @menuItemIndex
        lg.setColor(1, 1, 1)
      elseif i.action
        lg.setColor(0.4, 0.4, 0.4)
      else
        lg.setColor(0.1, 0.1, 0.1)

      y = (lovebite.height/2) + (c-1)*16
      lg.printf(i.display, 0, y, lovebite.width - 20, "right")

    lovebite\endDraw!

  update: (dt) =>
    controls\update!

    if controls\pressed("confirm")
      menuItem = @menuItems[@menuItemIndex]

      if menuItem.action
        log.info(string.format("Selected '%s'", menuItem.display))
        menuItem.action!
        _G.uiConfirmSound\play!
      else
        _G.uiDenySound\play!
        log.info(string.format("Selected '%s': no bound action", menuItem.display))

    if controls\pressed("up")
      @menuItemIndex -= 1
      _G.uiSound\play!
      log.trace("Menu item - 1")

    if controls\pressed("down")
      @menuItemIndex += 1
      _G.uiSound\play!
      log.trace("Menu item + 1")

    if controls\released("quit")
      love.event.quit!

    @menuItemIndex = lume.clamp(@menuItemIndex, 1, #@menuItems)

return MainMenu