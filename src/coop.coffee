class @Coop
  constructor: (@randomizer, @eggView)->
    @eggsPresent = []

  init: ->
    @throwNewEgg()
    setInterval (=> @tick()), 500

  throwNewEgg: ->
    @eggsPresent.unshift(new Egg(@randomizer.nextRandomLine(), @eggView))

  tick: ->
    egg = @eggsPresent.pop()
    if egg.aboutToFall()
      egg.hide()
      @throwNewEgg()
    else
      egg.move()
      @eggsPresent.unshift(egg)
