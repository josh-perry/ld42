log = _G.log

class Card
  new: (cardFile) =>
    cardFile = require(cardFile)

    @name = cardFile.name or "Mystery Card"
    @floor = cardFile.floor
    @type = cardFile.type or "effect"
    @description = cardFile.description or ""
    @diceBoosts = cardFile.diceBoosts
    @stats = cardFile.stats
    @successMin = cardFile.successMin or 0
    @sprite = love.graphics.newImage(cardFile.sprite or "img/card_back.png")
    @effects = cardFile.effects or {
      () =>
        log.error(string.format("No effect associated with card '%s'", cardFile))
    }
    @unique = cardFile.unique

return Card