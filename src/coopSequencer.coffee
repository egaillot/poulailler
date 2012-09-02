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


ADDITIONAL_EGG_POSITION =
  2: 2
  3: 2
  4: 7
  5: 2
  6: 12

class @CoopSequencer extends Sequencer
  constructor: (@tickDuration, @coop)->
    super @coop
    @coop.onAccelerate => @tickDuration -= 5
    @coop.onSlowDown => @tickDuration += 15
    @coop.onReachingNewLevel (levelReached)=> @handleNewLevelReached(levelReached)

  handleNewLevelReached: (levelReached)->
    @additionalEggPosition = ADDITIONAL_EGG_POSITION[levelReached]
    if levelReached == 2
      setTimeout (=> @tickDuration /= 2), @additionalEggPosition * @tickDuration - 10

  doBeforeStarting: ->
    @fullCycle = Egg.ABOUT_TO_FALL_POSITION + 1
    @positionInCycle = 0
    @additionalEggPosition = -1

    @coop.throwNewEgg()

  fireNextTick: ->
    return if @stopTicking
    setTimeout =>
      @moveInCycle()
      @fireNextTick()
    , @tickDuration

  moveInCycle: ->
    if @additionalEggPosition == @positionInCycle
      @additionalEggPosition = -1
      @positionInCycle = 0
      @fullCycle += Egg.ABOUT_TO_FALL_POSITION + 1
      @coop.throwNewEgg()
    else
      @coop.tick()
      @positionInCycle = (@positionInCycle + 1) % @fullCycle
