describe 'The Chicken Coop', ->
  beforeEach ->
    @view =
      displayEgg: ->
      eraseEgg: ->
      displayBucket: ->
      eraseBucket: ->
      fireGameOverSequence: jasmine.createSpy 'fireGameOverSequence'
      fireMissSequence: jasmine.createSpy('fireMissSequence')
                               .andCallFake (side, callback)-> callback()


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
    expect(@scorer.addPoint).wasNotCalled()
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



  describe '(when bucket not under falling egg)', ->
    beforeEach ->
      @getNewEggBroken()

    it 'updates missed points', ->
      expect(@scorer.addMiss).toHaveBeenCalledWith 1

    it 'does not add point', ->
      expect(@scorer.addPoint).wasNotCalled()

    it 'does not check whether a new level has been reached', ->
      expect(@scorer.hasReachedNewLevel).wasNotCalled()

    it 'gets into miss sequence', ->
      expect(@view.fireMissSequence).toHaveBeenCalled()
      expect(@view.fireMissSequence.mostRecentCall.args[0]).toEqual View.LEFT




  it 'fires right miss sequence when egg breaks on right', ->
    @randomizer.nextRandomLine = -> 1

    @getNewEggBroken()

    expect(@view.fireMissSequence).toHaveBeenCalled()
    expect(@view.fireMissSequence.mostRecentCall.args[0]).toEqual View.RIGHT

  it 'notifies when game is over', ->
    @scorer.gameOver = -> true
    gameOver = false
    @coop.onGameOver(-> gameOver = true)

    @getNewEggBroken()

    expect(gameOver).toBeTruthy()
    expect(@view.fireGameOverSequence).toHaveBeenCalled()

  it 'notifies when game should accelerate', ->
    @scorer.shouldAccelerate = -> true
    gotCalled = false
    @coop.onAccelerate -> gotCalled = true

    @getNewEggInBucket()
    expect(gotCalled).toBeTruthy()
