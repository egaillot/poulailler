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
    @levelThresholds[level] = threshold

  atLevel: (l)->
    @score == @levelThresholds[l] 

  resetLevelThresholds: ->
    @levelThresholds =
      1: 0
      2: 5
      3: 20
