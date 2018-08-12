return {
  name: "White Plains",
  type: "effect",
  sprite: "img/white plains.png",
  description: "A soothing field of peace and serenity.",
  effects: {
    {
      name: "Walk",
      action: (player) ->
        player.health += 1
        player.power -= 1
        player.agility += 2
    }
  }
}