describe 'The Chicken Coop', ->

  beforeEach ->
    @view =
      displayEgg: ->
      eraseEgg: ->

    @randomizer = 
      nextRandomLine: ->
        return @cpt += 1 unless @cpt == undefined
        return @cpt = 10

    @scorer = 
      addPoint: jasmine.createSpy 'addPoint'
      hasReachedNewLevel: -> false

    @coop = new Coop @scorer, @randomizer, @view

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
    expect(@coop.eggsPresent[0].line).toEqual 10

    @coop.tick() for i in [0..4]

    expect(@coop.eggsPresent.length).toEqual 1
    expect(@coop.eggsPresent[0].position).toEqual 0
    expect(@coop.eggsPresent[0].line).toEqual 11

  it 'keeps count of how many eggs have fallen', ->
    @coop.throwNewEgg()
    @coop.tick() for i in [0..3]
    expect(@scorer.addPoint).wasNotCalled()

    @coop.tick()

    expect(@scorer.addPoint).toHaveBeenCalled()

  describe 'throws more eggs at once when reaching higher levels', ->
    beforeEach ->
      @scorer.hasReachedNewLevel = -> true
      @coop.tickDuration = 100

    it 'at level 2', ->
      @scorer.levelReached = -> 2

      @coop.throwNewEgg()
      @coop.tick() for i in [0..4]

      waits(250)
      runs => 
        expect(@coop.eggsPresent.length).toEqual 2
        expect(@coop.tickDuration).toEqual 50

    it 'at level 3', ->
      @scorer.levelReached = -> 3

      @coop.throwNewEgg()
      @coop.tick() for i in [0..4]

      waits(400)
      runs =>
        expect(@coop.eggsPresent.length).toEqual 2
        expect(@coop.tickDuration).toEqual 100
