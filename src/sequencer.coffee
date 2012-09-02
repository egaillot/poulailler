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


class @Sequencer
  constructor: (coop)->
    coop.onStopTicking => @stop()
    coop.onResumeTicking => @resume()

  start: ->
    @doBeforeStarting()
    @resume()

  stop: ->
    @stopTicking = true

  resume: ->
    @stopTicking = false
    @fireNextTick()

  doBeforeStarting: ->

  fireNextTick: ->
