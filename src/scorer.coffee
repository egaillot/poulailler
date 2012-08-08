class @Scorer
  constructor: (@view)->
    @score = 0
    @view.displayScore(@score) 
    @resetLevelThresholds()

  addPoint: ->
    @score += 1
    @view.displayScore(@score) 

  levelThreshold: (level)->
    @levelThresholds[level]

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
