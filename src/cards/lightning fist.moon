return {
  name: "Lightning Fist",
  description: "You're embued with lightning!"
  sprite: "img/lightning fist.png"
  effects: {
    {
      name: "Channel it into Agility",
      action: (player) ->
        player.power -= 1
        player.agility += 1
    },
    {
      name: "Channel it into Power",
      action: (player) ->
        player.power += 1
        player.agility -= 1
    }
  }
}