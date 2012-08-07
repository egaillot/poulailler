describe 'The Chicken Coop', ->

  beforeEach ->
    @eggView =
      display: ->
      erase: ->

  it 'can throw an egg down the line', ->
    coop = new Coop @eggView
    expect(coop.eggsPresent.length).toEqual 0
    coop.throwNewEgg()
    expect(coop.eggsPresent.length).toEqual 1

  it 'can move an egg down the line', ->
    coop = new Coop @eggView
    coop.throwNewEgg()
    coop.tick()
    expect(coop.eggsPresent[0].position).toEqual 1

  it 'throws new egg when current egg at end of line', ->
    coop = new Coop @eggView
    coop.throwNewEgg()
    for i in [0..4]
      coop.tick()
    expect(coop.eggsPresent.length).toEqual 1
    expect(coop.eggsPresent[0].position).toEqual 0
