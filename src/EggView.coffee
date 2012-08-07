class @EggView

  display: (line, position)->
    $(".line-#{line}.egg-#{position}").show()

  erase: (line, position)->
    $(".line-#{line}.egg-#{position}").hide()
