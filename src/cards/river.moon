return {
  name: "River",
  type: "effect",
  sprite: "img/river.png",
  description: "A rushing blue river.",
  floor: 1,
  effects: {
    {
      name: "Ford",
      action: (player) ->
        player.agility += 1
    }
  }
}