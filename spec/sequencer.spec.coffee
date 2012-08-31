class SimpleSequencer extends Sequencer
  constructor: ->
    coop =
      onStopTicking: ->
      onResumeTicking: ->

    super coop



describe 'A simple Sequencer', ->
  beforeEach ->
    @sequencer = new SimpleSequencer
    @sequencer.doBeforeStarting = jasmine.createSpy 'doBeforeStarting'
    @sequencer.fireNextTick = jasmine.createSpy 'fireNextTick'

  it 'invokes doBeforeStarting, before starting', ->
    expect(@sequencer.doBeforeStarting).not.toHaveBeenCalled()
    @sequencer.start()
    expect(@sequencer.doBeforeStarting).toHaveBeenCalled()

  it 'fires a tick at start', ->
    expect(@sequencer.fireNextTick).not.toHaveBeenCalled()
    @sequencer.start()
    expect(@sequencer.fireNextTick).toHaveBeenCalled()

