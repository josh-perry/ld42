log = _G.log

class Card
  new: (cardFile) =>
    cardFile = require(cardFile)

    @name = cardFile.name or "Mystery Card"

    @effects = cardFile.effects or {
      () =>
        log.error(string.format("No effect associated with card '%s'", cardFile))
    }

return Card