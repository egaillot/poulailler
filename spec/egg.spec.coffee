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


describe "An egg", ->

  beforeEach ->
    @view =
      displayEgg: jasmine.createSpy 'displayEgg'
      eraseEgg: jasmine.createSpy 'eraseEgg'

    @sound =
      playEggLineBeep: jasmine.createSpy 'playEggLineBeep'

  it "can be seen and heard", ->
    egg = new Egg 42, @view, @sound
    expect(@view.displayEgg).toHaveBeenCalledWith 42, 0
    expect(@sound.playEggLineBeep).toHaveBeenCalledWith 42

  it "can move", ->
    egg = new Egg 0, @view, @sound
    expect(egg.position).toEqual 0
    egg.move()
    expect(egg.position).toEqual 1

  it "can hide itself", ->
    egg = new Egg 4807, @view, @sound
    egg.move()
    expect(@view.eraseEgg).toHaveBeenCalledWith 4807, 0
    expect(@view.displayEgg).toHaveBeenCalledWith 4807, 1

  it "knows when it is about to fall", ->
    egg = new Egg 0, @view, @sound
    egg.position = 3
    expect(egg.aboutToFall()).toBeFalsy()
    egg.position = 4
    expect(egg.aboutToFall()).toBeTruthy()

  describe "knows on which side it lies", ->
    beforeEach ->
      @expectSide = (expectedSide, eggLine)=>
        egg = new Egg eggLine, @view, @sound
        expect(egg.side()).toEqual expectedSide

    it "on line 0", ->
      @expectSide View.LEFT, 0

    it "on line 1", ->
      @expectSide View.RIGHT, 1

    it "on line 2", ->
      @expectSide View.LEFT, 2

    it "on line 3", ->
      @expectSide View.RIGHT, 3
