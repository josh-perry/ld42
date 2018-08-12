return {
  name: "Forest",
  type: "effect",
  sprite: "img/forest.png",
  description: "A calming wooded area.",
  floor: 1,
  effects: {
    {
      name: "Rest",
      action: (player) ->
        player.health += 2
    }
  }
}