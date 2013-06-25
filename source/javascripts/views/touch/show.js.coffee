class App.Views.Touch extends Backbone.View
  el: "body"
  events:
    touchstart: 'touchstart'
    touchmove:  'touchmove'
    touchend:   'touchend'

  initialize: ->
    @$right = $("#sidebar, #bar")
    @$margin_right = $("#main")
    @offset = parseInt @$right.css('right')

  touchstart: (event) =>
    return if event.originalEvent.touches.length isnt 1

    @swiping        = @$main.offset().left isnt 0
    @touch_start_x  = event.originalEvent.touches[0].pageX - @$main.offset().left
    @touch_start_y  = event.originalEvent.touches[0].pageY - @$main.offset().top
    @previous_x     = @touch_start_x
    @previous_time  = event.timeStamp
    @pixels_per_sec = 0

    if @swiping
      @$main.stop(true)

  touchmove: (event) =>
    return if event.originalEvent.touches.length isnt 1

    x = event.originalEvent.touches[0].pageX
    y = event.originalEvent.touches[0].pageY

    movement_x = x - @touch_start_x
    movement_y = y - @touch_start_y

    if not @swiping and Math.abs(movement_x) > 30 and Math.abs(movement_x) > Math.abs(movement_y)
      @swiping = true

    return unless @swiping

    if @$main.offset().left isnt 0
      event.preventDefault()

    movement_x = _.min [movement_x, 0]
    movement_x = _.max [movement_x, -300]

    @pixels_per_sec = (x - @previous_x) / (event.timeStamp - @previous_time) * 1000

    @$main.css  x: movement_x

    @previous_x = x
    @previous_time = event.timeStamp

  touchend: (event) =>
    return if event.originalEvent.touches.length isnt 0
    left  = @$main.offset().left

    if left + @pixels_per_sec < -150
      x = -300
    else
      x = 0

    @$main.transit x: x, 200
