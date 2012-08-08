class @View

  displayEgg: (line, position)->
    $(".line-#{line}.egg-#{position}").show()

  eraseEgg: (line, position)->
    $(".line-#{line}.egg-#{position}").hide()

  displayScore: (score)->
    $('.score').text score
