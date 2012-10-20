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


describe 'The Chicken Coop', ->
  beforeEach ->
    @soundSystem =
      playEggLineBeep: ->
      playGotIt: jasmine.createSpy 'playGotIt'

    @eggFactory =
      nextLine: ->
        return @cpt += 1 unless @cpt == undefined
        return @cpt = 0
      newEgg: ->
        new Egg @nextLine()

    @scorer =
      addPoint: jasmine.createSpy 'addPoint'
      addMiss: jasmine.createSpy 'addMiss'
      hasReachedNewLevel: jasmine.createSpy('hasReachedNewLevel').andReturn false
      gameOver: -> false
      shouldAccelerate: -> false
      shouldSlowDown: -> false

    @bucket = { position: 0 }

    @coop = new Coop @bucket, @scorer, @eggFactory, @soundSystem
    @callback = jasmine.createSpy('missed egg callback')
                       .andCallFake (side, shouldAnimate, callback)-> callback()
    @coop.onMissedEgg @callback

    @getNewEggInBucket = =>
      @coop.throwNewEgg()
      @coop.tick() for i in [0..4]

    @getNewEggBroken = =>
      @coop.throwNewEgg()
      @bucket.position = 3
      @coop.tick() for i in [0..4]




  it 'can throw an egg down the line', ->
    expect(@coop.eggsPresent.length).toEqual 0
    @coop.throwNewEgg()
    expect(@coop.eggsPresent.length).toEqual 1

  it 'can move an egg down the line', ->
    @coop.throwNewEgg()
    @coop.tick()
    expect(@coop.eggsPresent[0].position).toEqual 1

  it 'keeps count of how many eggs have fallen', ->
    @coop.throwNewEgg()
    @coop.tick() for i in [0..3]
    expect(@scorer.addPoint).not.toHaveBeenCalled()
    @coop.tick()
    expect(@scorer.addPoint).toHaveBeenCalled()




  describe '(when egg falls into bucket)', ->
    beforeEach ->
      @scorer.hasReachedNewLevel = -> true
      @scorer.levelReached = -> 3
      @gotNotified = 0
      @coop.onReachingNewLevel (newLevel)=> @gotNotified = newLevel

      @getNewEggInBucket()

    it 'signals when reaching new level', ->
      expect(@gotNotified).toEqual 3

    it 'throws new egg when current egg at end of line', ->
      expect(@coop.eggsPresent.length).toEqual 1
      expect(@coop.eggsPresent[0].position).toEqual 0
      expect(@coop.eggsPresent[0].line).toEqual 1

    it 'plays a "got it" beep', ->
      expect(@soundSystem.playGotIt).toHaveBeenCalled()



  describe '(when bucket not under falling egg and Minnie not displayed)', ->
    beforeEach ->
      @coop.hideMinnie()
      @getNewEggBroken()

    it 'adds 2 missed points when Minnie is not displayed', ->
      expect(@scorer.addMiss).toHaveBeenCalledWith 2

    it 'does not add point', ->
      expect(@scorer.addPoint).not.toHaveBeenCalled()

    it 'does not check whether a new level has been reached', ->
      expect(@scorer.hasReachedNewLevel).not.toHaveBeenCalled()

    it 'fires non-animated miss sequence', ->
      expect(@callback).toHaveBeenCalled()
      expect(@callback.mostRecentCall.args[0]).toEqual CoopView.LEFT
      expect(@callback.mostRecentCall.args[1]).toEqual false



  describe '(when bucket not under falling egg and Minnie displayed)', ->
    beforeEach ->
      @coop.showMinnie()
      @getNewEggBroken()

    it 'adds 1 missed point when egg brakes and Minnie is displayed', ->
      expect(@scorer.addMiss).toHaveBeenCalledWith 1

    it 'fires animated miss sequence', ->
      expect(@callback).toHaveBeenCalled()
      expect(@callback.mostRecentCall.args[1]).toEqual true


  it 'fires right miss sequence when egg breaks on right', ->
    @eggFactory.nextLine = -> 1

    @getNewEggBroken()

    expect(@callback).toHaveBeenCalled()
    expect(@callback.mostRecentCall.args[0]).toEqual CoopView.RIGHT

  it 'notifies when game is over', ->
    @scorer.gameOver = -> true
    gotCalled = false
    @coop.onStopTicking -> gotCalled = true

    gameOverCallback = jasmine.createSpy 'game over callback'
    @coop.onGameOver gameOverCallback

    @getNewEggBroken()

    expect(gotCalled).toBeTruthy()
    expect(gameOverCallback).toHaveBeenCalled()

  it 'notifies when game should accelerate', ->
    @scorer.shouldAccelerate = -> true
    gotCalled = false
    @coop.onAccelerate -> gotCalled = true

    @getNewEggInBucket()
    expect(gotCalled).toBeTruthy()

  it 'notifies when game should slow down', ->
    @scorer.shouldSlowDown = -> true
    gotCalled = false
    @coop.onSlowDown -> gotCalled = true

    @getNewEggInBucket()
    expect(gotCalled).toBeTruthy()

  it 'notifies when to stop / resume ticking', ->
    stopGotCalled = false
    otherStopGotCalled = false
    resumeGotCalled = false
    otherResumeGotCalled = false
    @coop.onStopTicking -> stopGotCalled = true
    @coop.onStopTicking -> otherStopGotCalled = true
    @coop.onResumeTicking -> resumeGotCalled = true

    @getNewEggBroken()
    expect(stopGotCalled).toBeTruthy()
    expect(otherStopGotCalled).toBeTruthy()
    expect(resumeGotCalled).toBeTruthy()

  it 'notifies its observer when Minnie appears', ->
    callback = jasmine.createSpy 'Minnie appearance callback'
    @coop.onMinnieAppearing callback
    @coop.showMinnie()
    expect(callback).toHaveBeenCalled()

  it 'notifies its observer when Minnie disappears', ->
    callback = jasmine.createSpy 'Minnie disappearance callback'
    @coop.onMinnieDisappearing callback
    @coop.hideMinnie()
    expect(callback).toHaveBeenCalled()

