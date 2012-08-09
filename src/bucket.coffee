class @Bucket
  constructor: (@view)->
    @position = 0
    @view.displayBucket @position

  moveTo: (newPosition)->
    @view.eraseBucket @position
    @position = newPosition
    @view.displayBucket @position
