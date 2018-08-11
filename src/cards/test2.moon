return {
  name: "Test 2",
  effects: {
    (player) ->
      player.wisdom -= 5
      player.power += 5
  }
}