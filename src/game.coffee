class @Game
  constructor: ->
    userInput = new UserInput
    view = new View
    scorer = new Scorer view

    randomizer =
      nextRandomLine: ->
        return @cpt = (@cpt + 1) % 4 unless @cpt == undefined
        return @cpt = 0

    coop = new Coop scorer, randomizer, view, userInput
    @coopSequencer = new CoopSequencer 500, coop
    @minnieSequencer = new MinnieSequencer coop

  init: ->
    @coopSequencer.start()
    @minnieSequencer.start()
