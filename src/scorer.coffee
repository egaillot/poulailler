class @Scorer
  constructor: (@view)->
    @score = 0
    @misses = 0
    @view.displayScore @score
    @view.displayMiss @misses
    @resetLevelThresholds()

  addPoint: ->
    @score += 1
    @view.displayScore @score

  addMiss: (m)->
    @misses += m
    @view.displayMiss @misses

  changeLevelThreshold: (level, threshold)->
    delete @levelThresholds[threshold]
    @levelThresholds[threshold] = level

  hasReachedNewLevel: ->
    @levelThresholds[@score] != undefined

  levelReached: ->
    @levelThresholds[@score]

  resetLevelThresholds: ->
    @levelThresholds =
      0: 1
      5: 2
      20: 3
      80: 4
      150: 5
      290: 6
