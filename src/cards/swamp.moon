return {
  name: "Swamp",
  type: "effect",
  sprite: "img/swamp.png",
  description: "A nasty bog.",
  effects: {
    {
      name: "Traverse",
      action: (player) ->
        player.health -= 1
    }
  }
}