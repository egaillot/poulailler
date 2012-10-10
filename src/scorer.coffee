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


class @Scorer
  constructor: ->
    @scoreCallback = ->
    @missCallback = ->
    @score = 0
    @misses = 0
    @resetLevelThresholds()

  onScoreChanged: (@scoreCallback)->
  onMissChanged: (@missCallback)->

  fireScoreChanged: ->
    @scoreCallback @score

  fireMissChanged: ->
    @missCallback @misses

  addPoint: ->
    @score += 1
    @fireScoreChanged @score

  addMiss: (m)->
    @misses += m
    @fireMissChanged @misses

  gameOver: ->
    @misses >= 6

  changeLevelThreshold: (level, threshold)->
    delete @levelThresholds[threshold]
    @levelThresholds[threshold] = level

  shouldAccelerate: ->
    @score % 10 == 0 && !@shouldSlowDown()

  shouldSlowDown: ->
    @score % 100 == 0

  hasReachedNewLevel: ->
    @levelThresholds[@score] != undefined

  levelReached: ->
    @levelThresholds[@score]

  resetLevelThresholds: ->
    @levelThresholds =
      0: 1
      5: 2
      20: 3
      80: 4
      150: 5
      290: 6
