class @SoundSystem
  playEggLineBeep: (eggLine)->
    beep = $ ".line-beep-#{eggLine}"
    return if beep.length == 0
    beep[0].play()

  playGotIt: ->
    $('.got-it')[0].play()
