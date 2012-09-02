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


describe "A scorer", ->
  beforeEach ->
    @view =
      displayScore: jasmine.createSpy 'displayScore'
      displayMiss: jasmine.createSpy 'displayMiss'
    @scorer = new Scorer @view
      
  it "keeps track of score", ->
    expect(@scorer.score).toEqual 0
    @scorer.addPoint()
    expect(@scorer.score).toEqual 1

  it "keeps track of misses", ->
    expect(@scorer.misses).toEqual 0
    @scorer.addMiss 1
    expect(@scorer.misses).toEqual 1

  it "displays score", ->
    expect(@view.displayScore).toHaveBeenCalledWith 0
    @scorer.addPoint()
    expect(@view.displayScore).toHaveBeenCalledWith 1

  it "displays misses", ->
    expect(@view.displayMiss).toHaveBeenCalledWith 0
    @scorer.addMiss 1
    expect(@view.displayMiss).toHaveBeenCalledWith 1
    @scorer.addMiss 3
    expect(@view.displayMiss).toHaveBeenCalledWith 4

  it "tells game is over at 6th missed point", ->
    @scorer.misses = 5
    expect(@scorer.gameOver()).toBeFalsy()
    @scorer.addMiss 1
    expect(@scorer.gameOver()).toBeTruthy()

  it "tells to slow down every 100 points", ->
    @scorer.score = 99
    expect(@scorer.shouldSlowDown()).toBeFalsy()
    @scorer.score = 100
    expect(@scorer.shouldSlowDown()).toBeTruthy()
    @scorer.score = 200
    expect(@scorer.shouldSlowDown()).toBeTruthy()

  it "tells to accelerate every 10 points, except when it tells to slow down", ->
    @scorer.score = 39
    expect(@scorer.shouldAccelerate()).toBeFalsy()
    @scorer.score = 40
    expect(@scorer.shouldAccelerate()).toBeTruthy()
    @scorer.score = 50
    expect(@scorer.shouldAccelerate()).toBeTruthy()
    @scorer.score = 100
    expect(@scorer.shouldAccelerate()).toBeFalsy()




  describe "tells which level we've reached", ->
    beforeEach ->
      @scorer.changeLevelThreshold 2, 18
      @scorer.changeLevelThreshold 3, 20

    it 'before level 2', ->
      @scorer.score = 1
      expect(@scorer.hasReachedNewLevel()).toBeFalsy()

    it 'at level 2', ->
      @scorer.score = 18
      expect(@scorer.hasReachedNewLevel()).toBeTruthy()
      expect(@scorer.levelReached()).toEqual 2

    it 'between level 2 and level 3', ->
      @scorer.score = 19
      expect(@scorer.hasReachedNewLevel()).toBeFalsy()

    it 'at level 3', ->
      @scorer.score = 20
      expect(@scorer.hasReachedNewLevel()).toBeTruthy()
      expect(@scorer.levelReached()).toEqual 3
