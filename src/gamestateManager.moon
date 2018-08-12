log = _G.log

class GamestateManager
  new: =>
    log.info("Loading gamestates")

    @gamestate = require("libs.hump.gamestate")
    @states = {
	    mainMenu: require("states.mainMenu")!
      game: require("states.game")!,
      cardResolution: require("states.cardResolution")!,
      equipmentCardResolution: require("states.equipmentCardResolution")!,
      combatCardResolution: require("states.combatCardResolution")!,
      boardDealing: require("states.boardDealing")!,
      gameOver: require("states.gameOver")!,
      gameWin: require("states.gameWin")!
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