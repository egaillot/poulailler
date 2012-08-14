animateSequence = ($sequence, stepDuration, callback)->
  blink = ($sprite)->
    $sprite.show()
    setTimeout (-> $sprite.hide()), stepDuration

  showNextElement = ($sequence)->
    blink($sequence.eq 0);
    animate($sequence[1..($sequence.length - 1)])

  animate = ($sequence) ->
    whatToDo = (-> showNextElement($sequence))
    whatToDo = callback if ($sequence.length == 0) 
    setTimeout whatToDo, stepDuration

  return if ($sequence.length == 0)
  showNextElement $sequence



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

  displayScore: (score)->
    $('.score').text score

  displayMiss: (miss)->
    $('.miss').text miss

  fireMissSequence: (side, callback)->
    sequence = '.right-sequence'
    sequence = '.left-sequence' if side == LEFT
    animateSequence $(sequence), 500, callback

  fireGameOverSequence: ->
    $('.game-over').show()

@View.LEFT = LEFT
@View.RIGHT = RIGHT
