describe "An egg", ->

  beforeEach ->
    @eggView =
      display: jasmine.createSpy('display')
      erase: jasmine.createSpy('erase')

  it "can display itself", ->
    egg = new Egg 42, @eggView
    expect(@eggView.display).toHaveBeenCalledWith 42, 0

  it "can move", ->
    egg = new Egg 0, @eggView
    expect(egg.position).toEqual 0
    egg.move()
    expect(egg.position).toEqual 1

  it "can hide itself", ->
    egg = new Egg 4807, @eggView
    egg.move()
    expect(@eggView.erase).toHaveBeenCalledWith 4807, 0
    expect(@eggView.display).toHaveBeenCalledWith 4807, 1

  it "knows when it is about to fall", ->
    egg = new Egg 0, @eggView
    egg.position = 3
    expect(egg.aboutToFall()).toBeFalsy()
    egg.position = 4
    expect(egg.aboutToFall()).toBeTruthy()
