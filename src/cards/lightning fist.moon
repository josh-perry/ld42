return {
  name: "Lightning Fist",
  type: "effect",
  description: "You're embued with lightning!",
  sprite: "img/lightning fist.png",
  floor: 1,
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