describe 'The Chicken Coop', ->
  beforeEach ->
    @view =
      displayEgg: ->
      eraseEgg: ->
      displayBucket: ->
      eraseBucket: ->
      displayMinnie: jasmine.createSpy 'displayMinnie'
      eraseMinnie: jasmine.createSpy 'eraseMinnie'
      fireGameOverSequence: jasmine.createSpy 'fireGameOverSequence'
      fireMissSequence: jasmine.createSpy('fireMissSequence')
                               .andCallFake (side, shouldAnimate, callback)-> callback()


    @userInput =
      onBucketPositionChange: (@callback)->

    @randomizer = 
      nextRandomLine: ->
        return @cpt += 1 unless @cpt == undefined
        return @cpt = 0

    @scorer = 
      addPoint: jasmine.createSpy 'addPoint'
      addMiss: jasmine.createSpy 'addMiss'
      hasReachedNewLevel: jasmine.createSpy('hasReachedNewLevel').andReturn false
      gameOver: -> false
      shouldAccelerate: -> false
      shouldSlowDown: -> false

    @coop = new Coop @scorer, @randomizer, @view, @userInput

    @getNewEggInBucket = =>
      @coop.throwNewEgg()
      @coop.tick() for i in [0..4]

    @getNewEggBroken = =>
      @coop.throwNewEgg()
      @userInput.callback UserInput.LOWER_RIGHT
      @coop.tick() for i in [0..4]




  it 'can throw an egg down the line', ->
    expect(@coop.eggsPresent.length).toEqual 0
    @coop.throwNewEgg()
    expect(@coop.eggsPresent.length).toEqual 1

  it 'can move an egg down the line', ->
    @coop.throwNewEgg()
    @coop.tick()
    expect(@coop.eggsPresent[0].position).toEqual 1

  it 'keeps count of how many eggs have fallen', ->
    @coop.throwNewEgg()
    @coop.tick() for i in [0..3]
    expect(@scorer.addPoint).not.toHaveBeenCalled()
    @coop.tick()
    expect(@scorer.addPoint).toHaveBeenCalled()



    
  describe '(when egg falls into bucket)', ->
    beforeEach ->
      @scorer.hasReachedNewLevel = -> true
      @scorer.levelReached = -> 3
      @gotNotified = 0
      @coop.onReachingNewLevel (newLevel)=> @gotNotified = newLevel

      @getNewEggInBucket()

    it 'signals when reaching new level', ->
      expect(@gotNotified).toEqual 3

    it 'throws new egg when current egg at end of line', ->
      expect(@coop.eggsPresent.length).toEqual 1
      expect(@coop.eggsPresent[0].position).toEqual 0
      expect(@coop.eggsPresent[0].line).toEqual 1



  describe '(when bucket not under falling egg and Minnie not displayed)', ->
    beforeEach ->
      @coop.hideMinnie()
      @getNewEggBroken()

    it 'adds 2 missed points when Minnie is not displayed', ->
      expect(@scorer.addMiss).toHaveBeenCalledWith 2

    it 'does not add point', ->
      expect(@scorer.addPoint).not.toHaveBeenCalled()

    it 'does not check whether a new level has been reached', ->
      expect(@scorer.hasReachedNewLevel).not.toHaveBeenCalled()

    it 'fires non-animated miss sequence', ->
      expect(@view.fireMissSequence).toHaveBeenCalled()
      expect(@view.fireMissSequence.mostRecentCall.args[0]).toEqual View.LEFT
      expect(@view.fireMissSequence.mostRecentCall.args[1]).toEqual false



  describe '(when bucket not under falling egg and Minnie displayed)', ->
    beforeEach ->
      @coop.showMinnie()
      @getNewEggBroken()

    it 'adds 1 missed point when egg brakes and Minnie is displayed', ->
      expect(@scorer.addMiss).toHaveBeenCalledWith 1

    it 'fires animated miss sequence', ->
      expect(@view.fireMissSequence).toHaveBeenCalled()
      expect(@view.fireMissSequence.mostRecentCall.args[1]).toEqual true


  it 'fires right miss sequence when egg breaks on right', ->
    @randomizer.nextRandomLine = -> 1

    @getNewEggBroken()

    expect(@view.fireMissSequence).toHaveBeenCalled()
    expect(@view.fireMissSequence.mostRecentCall.args[0]).toEqual View.RIGHT

  it 'notifies when game is over', ->
    @scorer.gameOver = -> true
    gotCalled = false
    @coop.onStopTicking -> gotCalled = true

    @getNewEggBroken()

    expect(gotCalled).toBeTruthy()
    expect(@view.fireGameOverSequence).toHaveBeenCalled()

  it 'notifies when game should accelerate', ->
    @scorer.shouldAccelerate = -> true
    gotCalled = false
    @coop.onAccelerate -> gotCalled = true

    @getNewEggInBucket()
    expect(gotCalled).toBeTruthy()

  it 'notifies when game should slow down', ->
    @scorer.shouldSlowDown = -> true
    gotCalled = false
    @coop.onSlowDown -> gotCalled = true

    @getNewEggInBucket()
    expect(gotCalled).toBeTruthy()

  it 'notifies when to stop / resume ticking', ->
    stopGotCalled = false
    otherStopGotCalled = false
    resumeGotCalled = false
    otherResumeGotCalled = false
    @coop.onStopTicking -> stopGotCalled = true
    @coop.onStopTicking -> otherStopGotCalled = true
    @coop.onResumeTicking -> resumeGotCalled = true

    @getNewEggBroken()
    expect(stopGotCalled).toBeTruthy()
    expect(otherStopGotCalled).toBeTruthy()
    expect(resumeGotCalled).toBeTruthy()

  it 'asks view to display Minnie', ->
    @coop.showMinnie()
    expect(@view.displayMinnie).toHaveBeenCalled()

  it 'asks view to erase Minnie', ->
    @coop.hideMinnie()
    expect(@view.eraseMinnie).toHaveBeenCalled()

