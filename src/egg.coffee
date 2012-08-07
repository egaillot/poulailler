EGG_ABOUT_TO_FALL_POSITION = 4

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

  aboutToFall: ->
    @position == EGG_ABOUT_TO_FALL_POSITION
