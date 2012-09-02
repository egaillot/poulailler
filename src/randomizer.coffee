class @Randomizer
  nextRandomLine: ->
    return @lastRandom = 0 if @lastRandom == undefined

    candidate = @lastRandom
    while candidate == @lastRandom
      candidate = Math.floor (Math.random() * 4)

    return @lastRandom = candidate
