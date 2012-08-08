class @Coop
  constructor: (@scorer, @randomizer, @view)->
    @eggsPresent = []

  init: ->
    @throwNewEgg()
    setInterval (=> @tick()), 500

  throwNewEgg: ->
    @eggsPresent.unshift(new Egg(@randomizer.nextRandomLine(), @view))

  tick: ->
    egg = @eggsPresent.pop()
    if egg.aboutToFall()
      egg.hide()
      @scorer.addPoint()
      @throwNewEgg()
    else
      egg.move()
      @eggsPresent.unshift(egg)
