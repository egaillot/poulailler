POSITIONS = [
  UserInput.UPPER_LEFT
  UserInput.UPPER_RIGHT
  UserInput.LOWER_LEFT
  UserInput.LOWER_RIGHT ]

class @Bucket
  constructor: (@view, @userInput)->
    @userInput.onBucketPositionChange (n)=>
      @moveTo(POSITIONS.indexOf n)
    @position = 0
    @view.displayBucket @position

  moveTo: (newPosition)->
    @view.eraseBucket @position
    @position = newPosition
    @view.displayBucket @position
