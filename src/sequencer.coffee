ADDITIONAL_EGG_POSITION =
  2: 2
  3: 2
  4: 7
  5: 2
  6: 12

class @Sequencer
  constructor: (@tickDuration, @coop)->
    @coop.onAccelerate => @tickDuration -= 5
    @coop.onSlowDown => @tickDuration += 15
    @coop.onReachingNewLevel (levelReached)=> @handleNewLevelReached(levelReached)
    @coop.onStopTicking => @stop()
    @coop.onResumeTicking => @resume()

  handleNewLevelReached: (levelReached)->
    @additionalEggPosition = ADDITIONAL_EGG_POSITION[levelReached]
    if levelReached == 2
      setTimeout (=> @tickDuration /= 2), @additionalEggPosition * @tickDuration - 10

  start: ->
    @fullCycle = Egg.ABOUT_TO_FALL_POSITION + 1
    @positionInCycle = 0
    @additionalEggPosition = -1

    @coop.throwNewEgg()
    @resume()

  stop: ->
    @stopTicking = true

  resume: ->
    @stopTicking = false
    @fireNextTick()

    unless @minnieCycleRunning
      @minnieCycleRunning = true
      @hideMinnie()

  fireNextTick: ->
    return if @stopTicking
    setTimeout =>
      @moveInCycle()
      @fireNextTick()
    , @tickDuration

  moveInCycle: ->
    if @additionalEggPosition == @positionInCycle
      @additionalEggPosition = -1
      @positionInCycle = 0
      @fullCycle += Egg.ABOUT_TO_FALL_POSITION + 1
      @coop.throwNewEgg()
    else
      @coop.tick()
      @positionInCycle = (@positionInCycle + 1) % @fullCycle

  hideMinnie: ->
    @handleTwoNextActionsInMinnieCycle (=> @coop.hideMinnie()), 4000, (=> @showMinnie())

  showMinnie: ->
    @handleTwoNextActionsInMinnieCycle (=> @coop.showMinnie()), 2000, (=> @hideMinnie())


  handleTwoNextActionsInMinnieCycle: (immediateCallback, delay, delayedCallback)->
    if @stopTicking
      @minnieCycleRunning = false
      return 

    immediateCallback()
    setTimeout -> 
      delayedCallback()
    , delay
    
