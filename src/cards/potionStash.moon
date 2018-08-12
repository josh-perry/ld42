return {
  name: "Potion Stash",
  type: "effect",
  sprite: "img/potion stash.png",
  description: "You can only take one!",
  floor: 1,
  effects: {
    {
      name: "Take an attack potion",
      action: (player) ->
        player.attackPotions += 1
    },
    {
      name: "Take a defense potion",
      action: (player) ->
        player.defensePotions += 1
    }
  }
}