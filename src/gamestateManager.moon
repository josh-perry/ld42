log = _G.log

class GamestateManager
  new: =>
    log.info("Loading gamestates")

    @gamestate = require("libs.hump.gamestate")
    @states = {
	    mainMenu: require("states.mainMenu")!
	    game: require("states.game")!
	  }

    log.info("Registering gamestate callbacks")
    @gamestate.registerEvents!

  switch: (state) =>
    log.info("Switching to state "..state)
    @gamestate.switch(@states[state])

return GamestateManager