describe "An egg", ->
  it "can move", ->
    egg = new Egg()
    expect(egg.position).toEqual 0
    egg.move()
    expect(egg.position).toEqual 1
