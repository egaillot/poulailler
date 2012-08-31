class @Coop
  constructor: (@scorer, @randomizer, @view, @userInput)->
    @newLevelCallback = ->
    @accelerateCallback = ->
    @slowDownCallback = ->
    @stopTickingCallbacks = []
    @resumeTickingCallbacks = []
    @minnieDisplayed = false
    @bucket = new Bucket @view, @userInput
    @eggsPresent = []

  onReachingNewLevel: (@newLevelCallback)->
  onAccelerate: (@accelerateCallback)->
  onSlowDown: (@slowDownCallback)->
  onStopTicking: (callback)-> @stopTickingCallbacks.push callback
  onResumeTicking: (callback)-> @resumeTickingCallbacks.push callback

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
    missedPoints = 1
    missedPoints = 2 unless @minnieDisplayed
    @scorer.addMiss missedPoints
    @fireMissSequence(egg.side(), @minnieDisplayed)

  fireMissSequence: (side, shouldAnimate)->
    callback() for callback in @stopTickingCallbacks
    @view.fireMissSequence side, shouldAnimate, =>
      if @scorer.gameOver()
        @view.fireGameOverSequence()
      else
        callback() for callback in @resumeTickingCallbacks
        @throwNewEgg()

  handleMovingEgg: (egg)->
    egg.move()
    @eggsPresent.unshift(egg)

  showMinnie: ->
    @minnieDisplayed = true
    @view.displayMinnie()

  hideMinnie: ->
    @minnieDisplayed = false
    @view.eraseMinnie()
