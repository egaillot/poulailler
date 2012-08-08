class @Coop
  constructor: (@scorer, @randomizer, @view)->
    @eggsPresent = []
    @tickDuration = 500

  init: ->
    @throwNewEgg()
    @fireNextTick()

  fireNextTick: ->
    setTimeout => 
      @tick()
      @fireNextTick()
    , @tickDuration

  throwNewEgg: ->
    @eggsPresent.unshift(new Egg(@randomizer.nextRandomLine(), @view))

  tick: ->
    egg = @eggsPresent.pop()
    if egg.aboutToFall() then @handleFallingEgg(egg) else @handleMovingEgg(egg)

  handleFallingEgg: (egg)->
    egg.hide()
    @scorer.addPoint()
    @throwNewEgg()
    @handleNewLevelReached() if @scorer.hasReachedNewLevel()

  handleNewLevelReached: ->
    if @scorer.levelReached() == 2
      setTimeout =>
        @throwNewEgg()
        @tickDuration /= 2
      , @tickDuration * 2.5

  handleMovingEgg: (egg)->
    egg.move()
    @eggsPresent.unshift(egg)
