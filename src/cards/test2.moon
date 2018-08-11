return {
  name: "Forest",
  sprite: "img/forest.png",
  description: "A calming wooded area.",
  effects: {
    (player) ->
      player.wisdom += 5
      player.power += 5
      player.agility += 5
  }
}