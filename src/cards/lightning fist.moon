return {
  name: "Lightning Fist",
  description: "You're embued with lightning!"
  sprite: "img/lightning fist.png"
  effects: {
    (player) ->
      player.power -= 5
      player.agility += 5,
    (player) ->
      player.power += 5
      player.agility -= 5,
  }
}