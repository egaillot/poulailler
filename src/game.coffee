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

POSITIONS = [
  UserInput.UPPER_LEFT
  UserInput.UPPER_RIGHT
  UserInput.LOWER_LEFT
  UserInput.LOWER_RIGHT ]

class @Game
  constructor: ->
    createBucket = (view)->
      userInput = new UserInput
      bucket = new Bucket view, userInput

      userInput.onBucketPositionChange (n)->
        bucket.moveTo(POSITIONS.indexOf n)

      bucket


    sound = new SoundSystem
    view = new View

    bucket = createBucket view
    scorer = new Scorer view
    randomizer = new Randomizer

    coop = new Coop bucket, scorer, randomizer, view, sound
    @coopSequencer = new CoopSequencer 500, coop
    @minnieSequencer = new MinnieSequencer coop

  init: ->
    @coopSequencer.start()
    @minnieSequencer.start()
