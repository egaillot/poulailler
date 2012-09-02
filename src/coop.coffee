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


class @Coop
  constructor: (@scorer, @randomizer, @view, @userInput)->
    @newLevelCallback = ->
    @accelerateCallback = ->
    @slowDownCallback = ->
    @stopTickingCallbacks = []
    @resumeTickingCallbacks = []
    @minnieDisplayed = false
    @bucket = new Bucket @view, @userInput
    @eggsPresent = []

  onReachingNewLevel: (@newLevelCallback)->
  onAccelerate: (@accelerateCallback)->
  onSlowDown: (@slowDownCallback)->
  onStopTicking: (callback)-> @stopTickingCallbacks.push callback
  onResumeTicking: (callback)-> @resumeTickingCallbacks.push callback

  throwNewEgg: ->
    @eggsPresent.unshift(new Egg(@randomizer.nextRandomLine(), @view))

  tick: ->
    egg = @eggsPresent.pop()
    if egg.aboutToFall() then @handleFallingEgg(egg) else @handleMovingEgg(egg)

  handleFallingEgg: (egg)->
    egg.hide()
    if egg.line == @bucket.position then @handleEggCaught() else @handleEggMissed egg

  handleEggCaught: ->
    @scorer.addPoint()
    @accelerateCallback() if @scorer.shouldAccelerate()
    @slowDownCallback() if @scorer.shouldSlowDown()
    @newLevelCallback(@scorer.levelReached()) if @scorer.hasReachedNewLevel()
    @throwNewEgg()

  handleEggMissed: (egg)->
    @inMissSequence = true
    missedPoints = 1
    missedPoints = 2 unless @minnieDisplayed
    @scorer.addMiss missedPoints
    @fireMissSequence(egg.side(), @minnieDisplayed)

  fireMissSequence: (side, shouldAnimate)->
    callback() for callback in @stopTickingCallbacks
    @view.fireMissSequence side, shouldAnimate, =>
      if @scorer.gameOver()
        @view.fireGameOverSequence()
      else
        callback() for callback in @resumeTickingCallbacks
        @throwNewEgg()

  handleMovingEgg: (egg)->
    egg.move()
    @eggsPresent.unshift(egg)

  showMinnie: ->
    @minnieDisplayed = true
    @view.displayMinnie()

  hideMinnie: ->
    @minnieDisplayed = false
    @view.eraseMinnie()
