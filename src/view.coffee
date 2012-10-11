# This file is part of Poulailler - a browser-revival
# of famous Nintendo's Game & Watch Mickey Mouse.
#
# Copyright 2012 Emmanuel Gaillot (emmanuel.gaillot@gmail.com)
#
# Poulailler is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Poulailler is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Poulailler.  If not, see <http://www.gnu.org/licenses/>.


animateSequence = (shouldAnimate, $sequence, stepDuration, callback)->
  playSound = ($sprite)->
    sound = $sprite.find('audio')
    return if sound.length == 0
    sound[0].play()


  blink = ($sprite, duration)->
    playSound $sprite
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

  displayBucket: (position)->
    $(".bucket-#{position}").show()

  eraseBucket: (position)->
    $(".bucket-#{position}").hide()

  displayMinnie: ->
    $('.minnie').show()

  eraseMinnie: ->
    $('.minnie').hide()

  fireMissSequence: (side, shouldAnimate, callback)->
    sequence = '.right-sequence'
    sequence = '.left-sequence' if side == LEFT
    animateSequence shouldAnimate, $(sequence), 500, callback

  fireGameOverSequence: ->
    $('.game-over').show()

@View.LEFT = LEFT
@View.RIGHT = RIGHT
