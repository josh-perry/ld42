log = _G.log

class Card
  new: (cardFile) =>
    cardFile = require(cardFile)

    @name = cardFile.name or "Mystery Card"
    @type = cardFile.type or "effect"
    @description = cardFile.description or ""
    @diceBoosts = cardFile.diceBoosts
    @sprite = love.graphics.newImage(cardFile.sprite or "img/card_back.png")
    @effects = cardFile.effects or {
      () =>
        log.error(string.format("No effect associated with card '%s'", cardFile))
    }

return Card