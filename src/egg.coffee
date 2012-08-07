class @Egg

  constructor: (@view)->
    @position = 0

  move: ->
    @position += 1

  show: ->
    @view.display @position

  hide: ->
    @view.erase @position
