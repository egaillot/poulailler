class @Coop
  constructor: (@scorer, @randomizer, @view, @userInput)->
    @newLevelCallback = ->
    @inMissSequence = false
    @bucket = new Bucket @view, @userInput
    @eggsPresent = []

  onReachingNewLevel: (@newLevelCallback)->

  throwNewEgg: ->
    @eggsPresent.unshift(new Egg(@randomizer.nextRandomLine(), @view))

  tick: ->
    return if @inMissSequence
    egg = @eggsPresent.pop()
    if egg.aboutToFall() then @handleFallingEgg(egg) else @handleMovingEgg(egg)

  handleFallingEgg: (egg)->
    egg.hide()
    if egg.line == @bucket.position then @handleEggCaught() else @handleEggMissed egg

  handleEggCaught: ->
    @scorer.addPoint()
    @newLevelCallback(@scorer.levelReached()) if @scorer.hasReachedNewLevel()
    @throwNewEgg()

  handleEggMissed: (egg)->
    @inMissSequence = true
    @scorer.addMiss 1
    @view.fireMissSequence egg.side(), =>
      @inMissSequence = false
      @throwNewEgg()

  handleMovingEgg: (egg)->
    egg.move()
    @eggsPresent.unshift(egg)
