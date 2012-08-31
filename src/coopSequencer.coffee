ADDITIONAL_EGG_POSITION =
  2: 2
  3: 2
  4: 7
  5: 2
  6: 12

class @CoopSequencer extends Sequencer
  constructor: (@tickDuration, @coop)->
    super @coop
    @coop.onAccelerate => @tickDuration -= 5
    @coop.onSlowDown => @tickDuration += 15
    @coop.onReachingNewLevel (levelReached)=> @handleNewLevelReached(levelReached)

  handleNewLevelReached: (levelReached)->
    @additionalEggPosition = ADDITIONAL_EGG_POSITION[levelReached]
    if levelReached == 2
      setTimeout (=> @tickDuration /= 2), @additionalEggPosition * @tickDuration - 10

  doBeforeStarting: ->
    @fullCycle = Egg.ABOUT_TO_FALL_POSITION + 1
    @positionInCycle = 0
    @additionalEggPosition = -1

    @coop.throwNewEgg()

  fireNextTick: ->
    return if @stopTicking
    setTimeout =>
      @moveInCycle()
      @fireNextTick()
    , @tickDuration

  moveInCycle: ->
    if @additionalEggPosition == @positionInCycle
      @additionalEggPosition = -1
      @positionInCycle = 0
      @fullCycle += Egg.ABOUT_TO_FALL_POSITION + 1
      @coop.throwNewEgg()
    else
      @coop.tick()
      @positionInCycle = (@positionInCycle + 1) % @fullCycle
