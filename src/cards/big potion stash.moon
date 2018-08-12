return {
  name: "Big Potion Stash",
  type: "effect",
  sprite: "img/big potion stash.png",
  description: "You can only take one!",
  floor: 2,
  effects: {
    {
      name: "Swipe a few attack potions",
      action: (player) ->
        player.attackPotions += 3
    },
    {
      name: "Grab some defense potions",
      action: (player) ->
        player.defensePotions += 3
    }
  }
}