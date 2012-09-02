describe 'The Randomizer', ->
  it 'returns 0 at first use', ->
    @randomizer = new Randomizer
    expect(@randomizer.nextRandomLine()).toEqual 0

  it 'returns a random numer between 0 and 3 after first use', ->
    Math.random = -> 0.99
    @randomizer = new Randomizer
    @randomizer.nextRandomLine()

    expect(@randomizer.nextRandomLine()).toEqual 3

  it 'returns a different random line each time', ->
    @randoms = [0, 0, 0.5]
    Math.random = =>
      @randoms.shift()
    @randomizer = new Randomizer
    @randomizer.nextRandomLine()

    expect(@randomizer.nextRandomLine()).toEqual 2


