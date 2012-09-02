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
