class @MinnieSequencer extends Sequencer
  constructor: (@coop)->
    super @coop

  fireNextTick: ->
    @getIntoNewMinnieCycle() unless @minnieCycleRunning

  getIntoNewMinnieCycle: ->
    @minnieCycleRunning = true
    @hideMinnie()

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
