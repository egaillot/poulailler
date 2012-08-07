describe "An egg", ->

  beforeEach ->
    @eggView =
      display: jasmine.createSpy('display')
      erase: jasmine.createSpy('erase')

  it "can display itself", ->
    egg = new Egg @eggView
    expect(@eggView.display).toHaveBeenCalledWith 0

  it "can move", ->
    egg = new Egg @eggView
    expect(egg.position).toEqual 0
    egg.move()
    expect(egg.position).toEqual 1

  it "can hide itself", ->
    egg = new Egg @eggView
    egg.move()
    expect(@eggView.erase).toHaveBeenCalledWith 0
    expect(@eggView.display).toHaveBeenCalledWith 1
