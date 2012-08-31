describe 'The Coop Sequencer', ->
  beforeEach ->
    jasmine.Clock.useMock()

    @coop =
      onAccelerate: ->
      onSlowDown: ->
      onReachingNewLevel: ->
      onStopTicking: ->
      onResumeTicking: ->
      throwNewEgg: jasmine.createSpy 'throwNewEgg'
      tick: jasmine.createSpy 'tick'

    @sequencer = new CoopSequencer 100, @coop

  it 'fires ticks at given frequency', ->
    @sequencer.start()

    jasmine.Clock.tick 99
    expect(@coop.tick).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.tick).toHaveBeenCalled()

    @coop.tick.reset()
    jasmine.Clock.tick 99
    expect(@coop.tick).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.tick).toHaveBeenCalled()

  it 'stops when told', ->
    @sequencer.start()
    @sequencer.stop()
    jasmine.Clock.tick 100
    @coop.tick.reset()

    jasmine.Clock.tick 100
    expect(@coop.tick).not.toHaveBeenCalled()

  it 'resumes when told', ->
    @sequencer.start()
    @sequencer.stop()
    jasmine.Clock.tick 100
    @coop.tick.reset()
    jasmine.Clock.tick 1000
    @sequencer.resume()
    jasmine.Clock.tick 99
    expect(@coop.tick).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.tick).toHaveBeenCalled()



  describe 'throws a new egg', ->
    it 'at start', ->
      @sequencer.start()
      expect(@coop.throwNewEgg).toHaveBeenCalled()

    it 'when reaching level 2', ->
      @sequencer.start()
      @coop.throwNewEgg.reset()
      jasmine.Clock.tick 500

      @sequencer.handleNewLevelReached 2

      jasmine.Clock.tick 189
      expect(@sequencer.tickDuration).toEqual 100
      jasmine.Clock.tick 1
      expect(@sequencer.tickDuration).toEqual 50

      jasmine.Clock.tick 59
      expect(@coop.throwNewEgg).not.toHaveBeenCalled()
      jasmine.Clock.tick 1
      expect(@coop.throwNewEgg).toHaveBeenCalled()

    it 'when reaching level 3', ->
      @sequencer.start()
      @coop.throwNewEgg.reset()
      jasmine.Clock.tick 500

      @sequencer.handleNewLevelReached 3

      jasmine.Clock.tick 299
      expect(@coop.throwNewEgg).not.toHaveBeenCalled()
      jasmine.Clock.tick 1
      expect(@coop.throwNewEgg).toHaveBeenCalled()
      expect(@sequencer.tickDuration).toEqual 100
