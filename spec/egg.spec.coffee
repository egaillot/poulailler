describe "An egg", ->

  it "can move", ->
    egg = new Egg
    expect(egg.position).toEqual 0
    egg.move()
    expect(egg.position).toEqual 1

  it "can display itself", ->
    eggView =
      display: jasmine.createSpy()

    egg = new Egg eggView
    egg.show()
    expect(eggView.display).toHaveBeenCalledWith 0
