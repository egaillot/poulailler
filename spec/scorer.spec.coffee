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
