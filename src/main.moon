-- Just for console logging niceness
print("")

-- Libs
log = require("libs.log")
log.level = "debug"

lovebite = require("libs.lovebite")
baton = require("libs.baton")

-- Shorthand
lg = love.graphics

setupScreen = ->
  internalWidth = 320
  internalHeight = 240

  log.info("Initializing lovebite")

  lovebite\setMode({
    width: internalWidth,
    height: internalHeight,
    scale: 3,
    flags: {
      vsync: true
    }
  })

  log.info(string.format("Internal resolution set to %ix%i", internalWidth, internalHeight))
  log.info(string.format("Window size set to %ix%i", lovebite.windowWidth, lovebite.windowHeight))

love.load = ->
  log.info("Starting up...")

  math.randomseed(os.time())
  love.graphics.setDefaultFilter("nearest", "nearest")

  setupScreen!

  log.info("Setting up controls")
  controls = require("config.controls")
  controls.joystick = love.joystick.getJoysticks![1] or nil

  _G.controls = baton.new(controls)
  _G.lovebite = lovebite
  _G.log = log
  _G.gamestateManager = require("gamestateManager")!
  _G.gamestateManager\switch("mainMenu")

  _G.cardSounds = {
    love.audio.newSource("sounds/card_1.wav", "static"),
    love.audio.newSource("sounds/card_2.wav", "static"),
    love.audio.newSource("sounds/card_3.wav", "static"),
    love.audio.newSource("sounds/card_4.wav", "static"),
    love.audio.newSource("sounds/card_5.wav", "static"),
    love.audio.newSource("sounds/card_6.wav", "static"),
    love.audio.newSource("sounds/card_7.wav", "static"),
    love.audio.newSource("sounds/card_8.wav", "static"),
    love.audio.newSource("sounds/card_9.wav", "static"),
    love.audio.newSource("sounds/card_10.wav", "static")
  }

  _G.diceSounds = {
    love.audio.newSource("sounds/dice_1.wav", "static"),
    love.audio.newSource("sounds/dice_2.wav", "static"),
    love.audio.newSource("sounds/dice_3.wav", "static"),
    love.audio.newSource("sounds/dice_4.wav", "static"),
    love.audio.newSource("sounds/dice_5.wav", "static"),
    love.audio.newSource("sounds/dice_6.wav", "static"),
    love.audio.newSource("sounds/dice_7.wav", "static"),
    love.audio.newSource("sounds/dice_8.wav", "static"),
    love.audio.newSource("sounds/dice_9.wav", "static"),
    love.audio.newSource("sounds/dice_10.wav", "static"),
    love.audio.newSource("sounds/dice_11.wav", "static"),
    love.audio.newSource("sounds/dice_1.wav", "static"),
    love.audio.newSource("sounds/dice_2.wav", "static"),
    love.audio.newSource("sounds/dice_3.wav", "static"),
    love.audio.newSource("sounds/dice_4.wav", "static"),
    love.audio.newSource("sounds/dice_5.wav", "static"),
    love.audio.newSource("sounds/dice_6.wav", "static"),
    love.audio.newSource("sounds/dice_7.wav", "static"),
    love.audio.newSource("sounds/dice_8.wav", "static"),
    love.audio.newSource("sounds/dice_9.wav", "static"),
    love.audio.newSource("sounds/dice_10.wav", "static"),
    love.audio.newSource("sounds/dice_11.wav", "static"),
    love.audio.newSource("sounds/dice_1.wav", "static"),
    love.audio.newSource("sounds/dice_2.wav", "static"),
    love.audio.newSource("sounds/dice_3.wav", "static"),
    love.audio.newSource("sounds/dice_4.wav", "static"),
    love.audio.newSource("sounds/dice_5.wav", "static"),
    love.audio.newSource("sounds/dice_6.wav", "static"),
    love.audio.newSource("sounds/dice_7.wav", "static"),
    love.audio.newSource("sounds/dice_8.wav", "static"),
    love.audio.newSource("sounds/dice_9.wav", "static"),
    love.audio.newSource("sounds/dice_10.wav", "static"),
    love.audio.newSource("sounds/dice_11.wav", "static")
  }

  _G.uiSound = love.audio.newSource("sounds/Blip_Select35.wav", "static")
  _G.uiConfirmSound = love.audio.newSource("sounds/Blip_Select43.wav", "static")
  _G.uiDenySound = love.audio.newSource("sounds/Blip_Select44.wav", "static")