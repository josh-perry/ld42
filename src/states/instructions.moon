lume = require("libs/lume")

log = _G.log
lg = love.graphics

local gsm
local lovebite
local controls
local fullscreen

class Instructions
  init: =>
    lovebite = _G.lovebite
    gsm = _G.gamestateManager
    controls = _G.controls

    fullscreen = false

    @font = lg.newFont("fonts/Pixel-UniCode.fnt")
    @background = love.graphics.newImage("img/background.png")
    @instructions = "Quick Instructions

Move around the board of cards to collect items, fight monsters and trigger effects.

You can't go back on cards you've already revealed. Eventually you'll run out of space and fight a boss.

Dice rolls of 4 and above are successes. Successful defense rolls offset successful attack rolls and damage dealt is the difference.
Potions give you additional dice for a round."

    @menuItems = {
      {
        display: "Restart",
        action: () -> love.event.quit("restart")
      }
      {
        display: "Quit",
        action: () -> love.event.quit!
      }
    }

    @menuItemIndex = 1

  draw: =>
    lovebite\startDraw!

    w, h = @background\getWidth!, @background\getHeight!
    for x = 0, lovebite.width / w
      for y = 0, lovebite.width / h
        love.graphics.draw(@background, x*w, y*h)

    lg.setFont(@font)
    lg.printf(@instructions, 0, 10, lovebite.width, "center")

    lovebite\endDraw!

  update: (dt) =>
    controls\update!

    if controls\pressed("confirm")
      gsm.states["game"] = require("states.game")!
      gsm\switch("boardDealing")

    if controls\released("quit")
      love.event.quit!

return Instructions