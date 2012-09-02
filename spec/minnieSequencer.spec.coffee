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


describe 'The Minnie Sequencer', ->
  beforeEach ->
    jasmine.Clock.useMock()

    @coop =
      onAccelerate: ->
      onSlowDown: ->
      onReachingNewLevel: ->
      onStopTicking: ->
      onResumeTicking: ->
      hideMinnie: jasmine.createSpy 'hideMinnie'
      showMinnie: jasmine.createSpy 'showMinnie'

    @sequencer = new MinnieSequencer @coop


  it 'triggers Minnie to show periodically', ->
    @sequencer.start()
    expect(@coop.hideMinnie).toHaveBeenCalled()
    @coop.hideMinnie.reset()

    jasmine.Clock.tick 3999
    expect(@coop.showMinnie).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.showMinnie).toHaveBeenCalled()
    @coop.showMinnie.reset()

    jasmine.Clock.tick 1999
    expect(@coop.hideMinnie).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.hideMinnie).toHaveBeenCalled()
    @coop.hideMinnie.reset()

    jasmine.Clock.tick 3999
    expect(@coop.showMinnie).not.toHaveBeenCalled()
    jasmine.Clock.tick 1
    expect(@coop.showMinnie).toHaveBeenCalled()
    @coop.showMinnie.reset()

  describe 'when stopped ticking', ->
    beforeEach ->
      @sequencer.start()
      @coop.hideMinnie.reset()

    it 'does not trigger Minnie to show', ->
      @sequencer.stop()
      jasmine.Clock.tick 4000
      expect(@coop.showMinnie).not.toHaveBeenCalled()

    it 'does not trigger Minnie to hide', ->
      jasmine.Clock.tick 4000
      @sequencer.stop()
      jasmine.Clock.tick 2000
      expect(@coop.hideMinnie).not.toHaveBeenCalled()

  it 're-enter Minnie cycle after resuming ticking', ->
      @sequencer.start()
      @sequencer.stop()
      jasmine.Clock.tick 4000

      @sequencer.resume()

      jasmine.Clock.tick 3999
      expect(@coop.showMinnie).not.toHaveBeenCalled()
      jasmine.Clock.tick 1
      expect(@coop.showMinnie).toHaveBeenCalled()

  it 'does not re-enter Minnie cycle twice', ->
      @sequencer.start()
      @sequencer.stop()
      @sequencer.resume()
      jasmine.Clock.tick 1000
      @sequencer.stop()
      jasmine.Clock.tick 2500
      @sequencer.resume()
      jasmine.Clock.tick 500
      expect(@coop.showMinnie).toHaveBeenCalled()
      @coop.showMinnie.reset()

      jasmine.Clock.tick 3500

      expect(@coop.showMinnie).not.toHaveBeenCalled()
