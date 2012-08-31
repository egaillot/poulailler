class @Coop
  constructor: (@scorer, @randomizer, @view, @userInput)->
    @newLevelCallback = ->
    @accelerateCallback = ->
    @slowDownCallback = ->
    @stopTickingCallback = ->
    @resumeTickingCallback = ->
    @bucket = new Bucket @view, @userInput
    @eggsPresent = []

  onReachingNewLevel: (@newLevelCallback)->
  onAccelerate: (@accelerateCallback)->
  onSlowDown: (@slowDownCallback)->
  onStopTicking: (@stopTickingCallback)->
  onResumeTicking: (@resumeTickingCallback)->

  throwNewEgg: ->
    @eggsPresent.unshift(new Egg(@randomizer.nextRandomLine(), @view))

  tick: ->
    egg = @eggsPresent.pop()
    if egg.aboutToFall() then @handleFallingEgg(egg) else @handleMovingEgg(egg)

  handleFallingEgg: (egg)->
    egg.hide()
    if egg.line == @bucket.position then @handleEggCaught() else @handleEggMissed egg

  handleEggCaught: ->
    @scorer.addPoint()
    @accelerateCallback() if @scorer.shouldAccelerate()
    @slowDownCallback() if @scorer.shouldSlowDown()
    @newLevelCallback(@scorer.levelReached()) if @scorer.hasReachedNewLevel()
    @throwNewEgg()

  handleEggMissed: (egg)->
    @inMissSequence = true
    @scorer.addMiss 1
    @fireMissSequence(egg.side())

  fireMissSequence: (side)->
    @stopTickingCallback()
    @view.fireMissSequence side, =>
      if @scorer.gameOver()
        @stopTickingCallback()
        @view.fireGameOverSequence()
      else
        @resumeTickingCallback()
        @throwNewEgg()

  handleMovingEgg: (egg)->
    egg.move()
    @eggsPresent.unshift(egg)

  showMinnie: ->
    @view.displayMinnie()

  hideMinnie: ->
    @view.eraseMinnie()
