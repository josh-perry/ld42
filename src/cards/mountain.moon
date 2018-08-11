return {
  name: "Mountain",
  type: "effect",
  sprite: "img/mountain.png",
  description: "A harsh place.",
  effects: {
    {
      name: "Train",
      action: (player) ->
        player.power += 1
    }
  }
}