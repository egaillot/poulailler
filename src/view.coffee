class @View

  displayEgg: (line, position)->
    $(".line-#{line}.egg-#{position}").show()

  eraseEgg: (line, position)->
    $(".line-#{line}.egg-#{position}").hide()

  displayBucket: (position)->
    $(".bucket-#{position}").show()

  eraseBucket: (position)->
    $(".bucket-#{position}").hide()

  displayScore: (score)->
    $('.score').text score
