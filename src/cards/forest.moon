return {
  name: "Forest",
  sprite: "img/forest.png",
  description: "A calming wooded area.",
  effects: {
    {
      name: "Rest",
      action: (player) ->
        player.health += 2
    }
  }
}