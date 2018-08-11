log = _G.log

class GamestateManager
  new: =>
    log.info("Loading gamestates")

    @gamestate = require("libs.hump.gamestate")
    @states = {
	    mainMenu: require("states.mainMenu")!
      game: require("states.game")!,
      cardResolution: require("states.cardResolution")!
	  }

    log.info("Registering gamestate callbacks")
    @gamestate.registerEvents!

  switch: (state, ...) =>
    log.info("Switching to state "..state)
    @gamestate.switch(@states[state], ...)

  push: (state, ...) =>
    log.info("Pushing state "..state)
    @gamestate.push(@states[state], ...)

  pop: (...) =>
    log.info("Popping state")
    @gamestate.pop(...)

return GamestateManager