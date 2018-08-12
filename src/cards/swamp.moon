return {
  name: "Swamp",
  type: "effect",
  sprite: "img/swamp.png",
  description: "A nasty bog.",
  floor: 2,
  effects: {
    {
      name: "Traverse",
      action: (player) ->
        player.health -= 1
    }
  }
}