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

  it "can be observed by several observers", ->
    displayCallback = jasmine.createSpy 'displayCallback'
    soundCallback = jasmine.createSpy 'soundCallback'
    egg = new Egg 42
    egg.onPositionChanged displayCallback
    egg.onPositionChanged soundCallback

    egg.firePositionChanged()

    expect(displayCallback).toHaveBeenCalledWith 42, 0
    expect(soundCallback).toHaveBeenCalledWith 42, 0

  it "can move", ->
    callback = jasmine.createSpy 'position change callback'
    egg = new Egg 0
    expect(egg.position).toEqual 0

    egg.onPositionChanged callback
    egg.move()

    expect(egg.position).toEqual 1
    expect(callback).toHaveBeenCalledWith 0, 1

  it "can hide", ->
    callback = jasmine.createSpy 'hide callback'
    egg = new Egg 3

    egg.onHide callback
    egg.hide()

    expect(callback).toHaveBeenCalledWith 3, 0

  it "knows when it is about to fall", ->
    egg = new Egg 0
    egg.position = 3
    expect(egg.aboutToFall()).toBeFalsy()
    egg.position = 4
    expect(egg.aboutToFall()).toBeTruthy()

  describe "knows on which side it lies", ->
    beforeEach ->
      @expectSide = (expectedSide, eggLine)=>
        egg = new Egg eggLine
        expect(egg.side()).toEqual expectedSide

    it "on line 0", ->
      @expectSide CoopView.LEFT, 0

    it "on line 1", ->
      @expectSide CoopView.RIGHT, 1

    it "on line 2", ->
      @expectSide CoopView.LEFT, 2

    it "on line 3", ->
      @expectSide CoopView.RIGHT, 3
