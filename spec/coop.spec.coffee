describe 'The Chicken Coop', ->

  beforeEach ->
    @eggView =
      display: jasmine.createSpy('display')
      erase: jasmine.createSpy('erase')

  it 'can throw an egg down the line', ->
    coop = new Coop @eggView
    expect(coop.eggsPresent.length).toEqual 0
    coop.throwNewEgg()
    expect(coop.eggsPresent.length).toEqual 1
