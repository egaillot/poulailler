animateSequence = (shouldAnimate, $sequence, stepDuration, callback)->
  blink = ($sprite, duration)->
    $sprite.show()
    setTimeout (-> $sprite.hide()), duration

  showNextElement = ($sequence, duration)->
    return if $sequence.length == 0
    blink $sequence.eq(0), duration
    setTimeout -> 
      showNextElement $sequence[1..($sequence.length - 1)], duration
    , duration

  return if ($sequence.length == 0)

  sequenceDuration = stepDuration * $sequence.length
  if shouldAnimate
    showNextElement $sequence, stepDuration
  else
    showNextElement $sequence.eq(0), sequenceDuration
  setTimeout callback, sequenceDuration



LEFT = 'left'
RIGHT = 'right'

class @View

  displayEgg: (line, position)->
    $(".line-#{line}.egg-#{position}").show()

  eraseEgg: (line, position)->
    $(".line-#{line}.egg-#{position}").hide()

  displayBucket: (position)->
    $(".bucket-#{position}").show()

  eraseBucket: (position)->
    $(".bucket-#{position}").hide()

  displayMinnie: ->
    $('.minnie').show()

  eraseMinnie: ->
    $('.minnie').hide()

  displayScore: (score)->
    $('.score').text score

  displayMiss: (miss)->
    $('.miss').text miss

  fireMissSequence: (side, shouldAnimate, callback)->
    sequence = '.right-sequence'
    sequence = '.left-sequence' if side == LEFT
    animateSequence shouldAnimate, $(sequence), 500, callback

  fireGameOverSequence: ->
    $('.game-over').show()

@View.LEFT = LEFT
@View.RIGHT = RIGHT
