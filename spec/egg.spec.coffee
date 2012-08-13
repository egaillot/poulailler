describe "An egg", ->

  beforeEach ->
    @view =
      displayEgg: jasmine.createSpy 'displayEgg'
      eraseEgg: jasmine.createSpy 'eraseEgg'

  it "can display itself", ->
    egg = new Egg 42, @view
    expect(@view.displayEgg).toHaveBeenCalledWith 42, 0

  it "can move", ->
    egg = new Egg 0, @view
    expect(egg.position).toEqual 0
    egg.move()
    expect(egg.position).toEqual 1

  it "can hide itself", ->
    egg = new Egg 4807, @view
    egg.move()
    expect(@view.eraseEgg).toHaveBeenCalledWith 4807, 0
    expect(@view.displayEgg).toHaveBeenCalledWith 4807, 1

  it "knows when it is about to fall", ->
    egg = new Egg 0, @view
    egg.position = 3
    expect(egg.aboutToFall()).toBeFalsy()
    egg.position = 4
    expect(egg.aboutToFall()).toBeTruthy()

  describe "knows on which side it lies", ->
    beforeEach ->
      @expectSide = (expectedSide, eggLine)=>
        egg = new Egg eggLine, @view
        expect(egg.side()).toEqual expectedSide

    it "on line 0", ->
      @expectSide View.LEFT, 0

    it "on line 1", ->
      @expectSide View.RIGHT, 1

    it "on line 2", ->
      @expectSide View.LEFT, 2

    it "on line 3", ->
      @expectSide View.RIGHT, 3
