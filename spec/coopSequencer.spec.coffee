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


describe 'The Coop Sequencer', ->
  beforeEach ->
    jasmine.Clock.useMock()

    @coop =
      onAccelerate: ->
      onSlowDown: ->
      onReachingNewLevel: ->
      onStopTicking: ->
      onResumeTicking: ->
      throwNewEgg: jasmine.createSpy 'throwNewEgg'
      tick: jasmine.createSpy 'tick'

    @sequencer = new CoopSequencer 100, @coop

  it 'fires ticks at given frequency', ->
    @sequencer.start()

    jasmine.Clock.tick 99
    expect(@coop.tick).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.tick).toHaveBeenCalled()

    @coop.tick.reset()
    jasmine.Clock.tick 99
    expect(@coop.tick).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.tick).toHaveBeenCalled()

  it 'stops when told', ->
    @sequencer.start()
    @sequencer.stop()
    jasmine.Clock.tick 100
    @coop.tick.reset()

    jasmine.Clock.tick 100
    expect(@coop.tick).not.toHaveBeenCalled()

  it 'resumes when told', ->
    @sequencer.start()
    @sequencer.stop()
    jasmine.Clock.tick 100
    @coop.tick.reset()
    jasmine.Clock.tick 1000
    @sequencer.resume()
    jasmine.Clock.tick 99
    expect(@coop.tick).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.tick).toHaveBeenCalled()



  describe 'throws a new egg', ->
    it 'at start', ->
      @sequencer.start()
      expect(@coop.throwNewEgg).toHaveBeenCalled()

    it 'when reaching level 2', ->
      @sequencer.start()
      @coop.throwNewEgg.reset()
      jasmine.Clock.tick 500

      @sequencer.handleNewLevelReached 2

      jasmine.Clock.tick 189
      expect(@sequencer.tickDuration).toEqual 100
      jasmine.Clock.tick 1
      expect(@sequencer.tickDuration).toEqual 50

      jasmine.Clock.tick 59
      expect(@coop.throwNewEgg).not.toHaveBeenCalled()
      jasmine.Clock.tick 1
      expect(@coop.throwNewEgg).toHaveBeenCalled()

    it 'when reaching level 3', ->
      @sequencer.start()
      @coop.throwNewEgg.reset()
      jasmine.Clock.tick 500

      @sequencer.handleNewLevelReached 3

      jasmine.Clock.tick 299
      expect(@coop.throwNewEgg).not.toHaveBeenCalled()
      jasmine.Clock.tick 1
      expect(@coop.throwNewEgg).toHaveBeenCalled()
      expect(@sequencer.tickDuration).toEqual 100
