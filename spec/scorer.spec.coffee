describe "A scorer", ->
  beforeEach ->
    @view =
      displayScore: jasmine.createSpy 'displayScore'
    @scorer = new Scorer @view
      
  it "keeps track of score", ->
    expect(@scorer.score).toEqual 0
    @scorer.addPoint()
    expect(@scorer.score).toEqual 1

  it "keeps track of misses", ->
    expect(@scorer.misses).toEqual 0
    @scorer.addMiss(1)
    expect(@scorer.misses).toEqual 1

  it "displays itself", ->
    @scorer = new Scorer @view
    expect(@view.displayScore).toHaveBeenCalledWith 0
    @scorer.addPoint()
    expect(@view.displayScore).toHaveBeenCalledWith 1

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
