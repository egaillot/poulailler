UPPER_LEFT= 101
LOWER_LEFT = 99
UPPER_RIGHT = 105
LOWER_RIGHT = 110

class @UserInput
  constructor: ->
    @callback = (n)->
    $('body').keypress((event) => @keyPressed(event))

  keyPressed: (event)->
    key = event.keyCode
    if key in [UPPER_LEFT, LOWER_LEFT, UPPER_RIGHT, LOWER_RIGHT]
      @callback key

  onBucketPositionChange: (@callback)->


@UserInput.UPPER_LEFT = UPPER_LEFT
@UserInput.LOWER_LEFT = LOWER_LEFT
@UserInput.UPPER_RIGHT = UPPER_RIGHT
@UserInput.LOWER_RIGHT = LOWER_RIGHT
