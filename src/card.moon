log = _G.log

class Card
  new: (cardFile) =>
    cardFile = require(cardFile)

    @name = cardFile.name or "Mystery Card"

    @effect = cardFile.effect or () =>
      log.error(string.format("No effect associated with card '%s'", cardFile))

return Card