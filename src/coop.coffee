TICKS_BEFORE_THROWING_NEW_EGG = 
  2: 2.5
  3: 4
  4: 1
  5: 3
  6: 2

class @Coop
  constructor: (@scorer, @randomizer, @view, @userInput)->
    @bucket = new Bucket @view, @userInput
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
    if egg.line == @bucket.position
      @scorer.addPoint()
      @handleNewLevelReached() if @scorer.hasReachedNewLevel()
    else
      @scorer.addMiss 1
    @throwNewEgg()

  handleNewLevelReached: ->
    levelReached = @scorer.levelReached()
    ticks = TICKS_BEFORE_THROWING_NEW_EGG[levelReached]
    setTimeout =>
      @throwNewEgg()
      @tickDuration /= 2 if levelReached == 2
    , ticks * @tickDuration

  handleMovingEgg: (egg)->
    egg.move()
    @eggsPresent.unshift(egg)
