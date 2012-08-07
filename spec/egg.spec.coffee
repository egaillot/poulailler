describe "An egg", ->

  it "can move", ->
    egg = new Egg
    expect(egg.position).toEqual 0
    egg.move()
    expect(egg.position).toEqual 1

  it "can display itself", ->
    eggView =
      display: jasmine.createSpy('display')

    egg = new Egg eggView
    egg.show()
    expect(eggView.display).toHaveBeenCalledWith 0

  it "can hide itself", ->
    eggView =
      erase: jasmine.createSpy('erase')

    egg = new Egg eggView
    egg.move()
    egg.hide()
    expect(eggView.erase).toHaveBeenCalledWith 1
