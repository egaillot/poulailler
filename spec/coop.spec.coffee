describe 'The Chicken Coop', ->

  beforeEach ->
    @eggView =
      display: ->
      erase: ->

    @randomizer = 
      nextRandomLine: ->
        return @cpt += 1 unless @cpt == undefined
        return @cpt = 10

  it 'can throw an egg down the line', ->
    coop = new Coop @randomizer, @eggView
    expect(coop.eggsPresent.length).toEqual 0
    coop.throwNewEgg()
    expect(coop.eggsPresent.length).toEqual 1

  it 'can move an egg down the line', ->
    coop = new Coop @randomizer, @eggView
    coop.throwNewEgg()
    coop.tick()
    expect(coop.eggsPresent[0].position).toEqual 1

  it 'throws new egg when current egg at end of line', ->
    coop = new Coop @randomizer, @eggView
    coop.throwNewEgg()
    expect(coop.eggsPresent[0].line).toEqual 10

    for i in [0..4]
      coop.tick()

    expect(coop.eggsPresent.length).toEqual 1
    expect(coop.eggsPresent[0].position).toEqual 0
    expect(coop.eggsPresent[0].line).toEqual 11
