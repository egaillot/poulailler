class @EggView

  display: (position)->
    $(".egg-#{position}").show()

  erase: (position)->
    $(".egg-#{position}").hide()
