class @Scorer
  constructor: (@view)->
    @score = 0
    @view.displayScore(@score) 

  addPoint: ->
    @score += 1
    @view.displayScore(@score) 
