describe 'The Sequencer', ->
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
      hideMinnie: jasmine.createSpy 'hideMinnie'
      showMinnie: jasmine.createSpy 'showMinnie'

    @sequencer = new Sequencer 100, @coop

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



  it 'triggers Minnie to show periodically', ->
    @sequencer.start()
    expect(@coop.hideMinnie).toHaveBeenCalled()
    @coop.hideMinnie.reset()

    jasmine.Clock.tick 3999
    expect(@coop.showMinnie).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.showMinnie).toHaveBeenCalled()
    @coop.showMinnie.reset()

    jasmine.Clock.tick 1999
    expect(@coop.hideMinnie).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.hideMinnie).toHaveBeenCalled()
    @coop.hideMinnie.reset()

    jasmine.Clock.tick 3999
    expect(@coop.showMinnie).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.showMinnie).toHaveBeenCalled()
    @coop.showMinnie.reset()

  describe 'when stopped ticking', ->
    beforeEach ->
      @sequencer.start()
      @coop.hideMinnie.reset()

    it 'does not trigger Minnie to show', ->
      @sequencer.stop()
      jasmine.Clock.tick 4000
      expect(@coop.showMinnie).not.toHaveBeenCalled()

    it 'does not trigger Minnie to hide', ->
      jasmine.Clock.tick 4000
      @sequencer.stop()
      jasmine.Clock.tick 2000
      expect(@coop.hideMinnie).not.toHaveBeenCalled()

  it 're-enter Minnie cycle after resuming ticking', ->
      @sequencer.start()
      @sequencer.stop()
      jasmine.Clock.tick 4000

      @sequencer.resume()

      jasmine.Clock.tick 3999
      expect(@coop.showMinnie).not.toHaveBeenCalled()
      jasmine.Clock.tick 1
      expect(@coop.showMinnie).toHaveBeenCalled()

  it 'does not re-enter Minnie cycle twice', ->
      @sequencer.start()
      @sequencer.stop()
      @sequencer.resume()
      jasmine.Clock.tick 1000
      @sequencer.stop()
      jasmine.Clock.tick 2500
      @sequencer.resume()
      jasmine.Clock.tick 500
      expect(@coop.showMinnie).toHaveBeenCalled()
      @coop.showMinnie.reset()

      jasmine.Clock.tick 3500

      expect(@coop.showMinnie).not.toHaveBeenCalled()
