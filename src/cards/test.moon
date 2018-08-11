return {
  name: "Test",
  effects: {
    (player) ->
      player.power -= 5
      player.agility += 5,
    (player) ->
      player.power += 5
      player.agility -= 5,
  }
}