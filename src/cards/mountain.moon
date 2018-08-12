return {
  name: "Mountain",
  type: "effect",
  sprite: "img/mountain.png",
  description: "A harsh place.",
  floor: 1,
  effects: {
    {
      name: "Train",
      action: (player) ->
        player.power += 1
    }
  }
}