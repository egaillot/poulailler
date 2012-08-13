describe 'The Chicken Coop', ->

  beforeEach ->
    @view =
      displayEgg: ->
      eraseEgg: ->
      displayBucket: ->
      eraseBucket: ->
      fireMissSequence: jasmine.createSpy 'fireMissSequence'

    @userInput =
      onBucketPositionChange: (@callback)->

    randomizer = 
      nextRandomLine: ->
        return @cpt += 1 unless @cpt == undefined
        return @cpt = 0

    @scorer = 
      addPoint: jasmine.createSpy 'addPoint'
      addMiss: jasmine.createSpy 'addMiss'
      hasReachedNewLevel: jasmine.createSpy('hasReachedNewLevel').andReturn false

    @coop = new Coop @scorer, randomizer, @view, @userInput

  it 'can throw an egg down the line', ->
    expect(@coop.eggsPresent.length).toEqual 0
    @coop.throwNewEgg()
    expect(@coop.eggsPresent.length).toEqual 1

  it 'can move an egg down the line', ->
    @coop.throwNewEgg()
    @coop.tick()
    expect(@coop.eggsPresent[0].position).toEqual 1

  it 'throws new egg when current egg at end of line', ->
    @coop.throwNewEgg()
    expect(@coop.eggsPresent[0].line).toEqual 0

    @coop.tick() for i in [0..4]

    expect(@coop.eggsPresent.length).toEqual 1
    expect(@coop.eggsPresent[0].position).toEqual 0
    expect(@coop.eggsPresent[0].line).toEqual 1

  it 'keeps count of how many eggs have fallen', ->
    @coop.throwNewEgg()
    @coop.tick() for i in [0..3]
    expect(@scorer.addPoint).wasNotCalled()

    @coop.tick()

    expect(@scorer.addPoint).toHaveBeenCalled()




  describe '(when bucket not under falling egg)', ->
    beforeEach ->
      @coop.throwNewEgg()
      @userInput.callback UserInput.LOWER_RIGHT
      @coop.tick() for i in [0..4]

    it 'updates missed points', ->
      expect(@scorer.addMiss).toHaveBeenCalledWith 1

    it 'does not add point', ->
      expect(@scorer.addPoint).wasNotCalled()

    it 'does not check whether a new level has been reached', ->
      expect(@scorer.hasReachedNewLevel).wasNotCalled()

    it 'gets into miss sequence', ->
      expect(@view.fireMissSequence).toHaveBeenCalled()
