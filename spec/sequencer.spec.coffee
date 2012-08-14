describe 'The Sequencer', ->
  describe 'makes the Chicken Coop throw more eggs at once', ->
    beforeEach ->
      @coop =
        onAccelerate: ->
        onSlowDown: ->
        onReachingNewLevel: ->
        onGameOver: ->
        throwNewEgg: jasmine.createSpy 'throwNewEgg'
      @sequencer = new Sequencer 100, @coop

    it 'when reaching level 2', ->
      @sequencer.handleNewLevelReached 2
      waits 250
      runs =>
        expect(@coop.throwNewEgg).toHaveBeenCalled()
        expect(@sequencer.tickDuration).toEqual 50

    it 'when reaching level 3', ->
      @sequencer.handleNewLevelReached 3
      waits 400
      runs =>
        expect(@coop.throwNewEgg).toHaveBeenCalled()
        expect(@sequencer.tickDuration).toEqual 100
