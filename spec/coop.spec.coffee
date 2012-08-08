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

  it 'can throw an egg down the line', ->
    coop = new Coop @scorer, @randomizer, @view
    expect(coop.eggsPresent.length).toEqual 0
    coop.throwNewEgg()
    expect(coop.eggsPresent.length).toEqual 1

  it 'can move an egg down the line', ->
    coop = new Coop @scorer, @randomizer, @view
    coop.throwNewEgg()
    coop.tick()
    expect(coop.eggsPresent[0].position).toEqual 1

  it 'throws new egg when current egg at end of line', ->
    coop = new Coop @scorer, @randomizer, @view
    coop.throwNewEgg()
    expect(coop.eggsPresent[0].line).toEqual 10

    coop.tick() for i in [0..4]

    expect(coop.eggsPresent.length).toEqual 1
    expect(coop.eggsPresent[0].position).toEqual 0
    expect(coop.eggsPresent[0].line).toEqual 11

  it 'keeps count of how many eggs have fallen', ->
    coop = new Coop @scorer, @randomizer, @view
    coop.throwNewEgg()
    coop.tick() for i in [0..3]
    expect(@scorer.addPoint).wasNotCalled()

    coop.tick()

    expect(@scorer.addPoint).toHaveBeenCalled()
