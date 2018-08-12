lume = require("libs/lume")

class Map
  new: (cardList, level) =>
    @cards = {}

    @level = level or 1

    -- The cards to make the board from
    @cardList = cardList

    @mapX, @mapY = 5, 5

    for x = 1, @mapX
      @cards[x] = {}

      for y = 1, @mapY
        c = lume.randomchoice(cardList)

        while c.unique
          c = lume.randomchoice(cardList)

        @cards[x][y] = require("boardCard")(c)

    @cards[1][1] = nil
    @cards[1][@mapY] = nil
    @cards[@mapX][1] = nil
    @cards[@mapX][@mapY] = nil
    @cards[3][3] = nil

    @bossCard = nil

    if @level == 1
      @bossCard = require("card")("cards/abomination")
    elseif @level == 2
      @bossCard = require("card")("cards/awakened avocado")

  draw: =>
    for cardX = 1, @mapX
      for cardY = 1, @mapY
        x = ((cardX * 24) + cardX * 8) - 8
        y = ((cardY * 32) + cardY * 8) - 8

        card = @cards[cardX][cardY]

        if card
          card\draw(x, y)

return Map