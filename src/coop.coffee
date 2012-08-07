class @Coop
  constructor: (@eggView)->
    @eggsPresent = []

  throwNewEgg: ->
    @eggsPresent.push(new Egg(@eggView))
