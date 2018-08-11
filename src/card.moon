log = _G.log

class Card
  new: (cardFile) =>
    cardFile = require(cardFile)

    @name = cardFile.name or "Mystery Card"

    @sprite = love.graphics.newImage(cardFile.sprite or "img/card_back.png")

    @effects = cardFile.effects or {
      () =>
        log.error(string.format("No effect associated with card '%s'", cardFile))
    }

return Card