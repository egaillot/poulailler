class @Sequencer
  constructor: (coop)->
    coop.onStopTicking => @stop()
    coop.onResumeTicking => @resume()

  start: ->
    @doBeforeStarting()
    @resume()

  stop: ->
    @stopTicking = true

  resume: ->
    @stopTicking = false
    @fireNextTick()

  doBeforeStarting: ->

  fireNextTick: ->
