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
    @view.displayEgg @line, @position

  hide: ->
    @view.eraseEgg @line, @position

  aboutToFall: ->
    @position == EGG_ABOUT_TO_FALL_POSITION

  side: ->
    if @line % 2 == 0 then View.LEFT else View.RIGHT


@Egg.ABOUT_TO_FALL_POSITION = EGG_ABOUT_TO_FALL_POSITION
