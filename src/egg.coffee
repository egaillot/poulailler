EGG_ABOUT_TO_FALL_POSITION = 4

class @Egg

  constructor: (@line, @view)->
    @position = 0
    @show()

  move: ->
    @hide()
    @position += 1
    @show()

  show: ->
    @view.display @line, @position

  hide: ->
    @view.erase @line, @position

  aboutToFall: ->
    @position == EGG_ABOUT_TO_FALL_POSITION
