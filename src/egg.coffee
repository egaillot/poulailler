class @Egg

  constructor: (@view)->
    @position = 0
    @show()

  move: ->
    @hide()
    @position += 1
    @show()

  show: ->
    @view.display @position

  hide: ->
    @view.erase @position
