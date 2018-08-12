return {
  name: "Scrying Ball",
  type: "effect",
  sprite: "img/scrying ball.png",
  description: "A clear glass sphere.",
  floor: 1,
  effects: {
    {
      name: "Look inside",
      action: (player, map) ->
        for cardX = 1, map.mapX
          for cardY = 1, map.mapY
            card = map.cards[cardX][cardY]

            if card and love.math.random(1, 2) == 1
              card.revealed = true
    }
  }
}