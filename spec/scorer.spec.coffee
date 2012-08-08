describe "A scorer", ->
  beforeEach ->
    @view =
      displayScore: jasmine.createSpy 'displayScore'
      
  it "keeps track of score", ->
    scorer = new Scorer @view
    expect(scorer.score).toEqual 0
    scorer.addPoint()
    expect(scorer.score).toEqual 1

  it "displays itself", ->
    scorer = new Scorer @view
    expect(@view.displayScore).toHaveBeenCalledWith 0
    scorer.addPoint()
    expect(@view.displayScore).toHaveBeenCalledWith 1
