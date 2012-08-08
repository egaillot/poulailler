describe "A scorer", ->
  it "keeps track of score", ->
    scorer = new Scorer
    expect(scorer.score).toEqual 0
    scorer.addPoint()
    expect(scorer.score).toEqual 1

