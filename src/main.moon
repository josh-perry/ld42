-- Just for console logging niceness
print("")

-- Libs
log = require("libs.log")
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

  setupScreen!

  log.info("Setting up controls")
  controls = require("config.controls")
  controls.joystick = love.joystick.getJoysticks![1] or nil

  _G.controls = baton.new(controls)
  _G.lovebite = lovebite
  _G.log = log
  _G.gamestateManager = require("gamestateManager")!
  _G.gamestateManager\switch("mainMenu")