class @Coop
  constructor: (@eggView)->
    @eggsPresent = []

  throwNewEgg: ->
    @eggsPresent.push(new Egg(@eggView))

  tick: ->
    for egg in @eggsPresent
      egg.move()
