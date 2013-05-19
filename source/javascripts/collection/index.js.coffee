class App.CollectionIndex extends Backbone.View
  el: "#content"
  events:
    "touchstart": "touchstart"
    "touchmove":  "touchmove"
    "touchend":  "touchend"

  initialize: ->
    @filter = ""
    @$main = $("#main")

    @listenTo @collection, "reset", @render
    @listenTo @collection, "add", @add
    $("#logo").on 'click', (event) =>
      @$el.scrollTo(0, duration: 200)

    $("#search").on 'input', (e) =>
      clearTimeout @input_timeout_id
      @filter = @clean($("#search").val())
      @input_timeout_id = setTimeout(@render, 10)

  render: =>
    @$ul = $("<ul>")
    @$el.html @$ul

    @collection.each (model) =>
      @add(model)

    this

  clean: (str) ->
    str.toLowerCase().replace(/[^a-z0-9\-]/g,'')

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
      # @touch_start_x = x
      # @touch_start_y = y

      # movement_x = x - @touch_start_x
      # movement_y = y - @touch_start_y

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

    # touch_x  = event.originalEvent.touches[0].pageX - @$main.offset().left
    # touch_y  = event.originalEvent.touches[0].pageY - @$main.offset().top

    # if left is 300 and touch_x is @touch_start_x and touch_y is @touch_start_y
    #   x = 0
    if left + @pixels_per_sec < -150
      x = -300
    else
      x = 0

    @$main.transit x: x, 200

  # scroll: (event) =>
  #   time = event.timeStamp
  #   y = @el.scrollTop
  #   pixels_per_sec = 0

  #   if @previous_time and @previous_y
  #     pixels_per_sec = (y - @previous_y) / (time - @previous_time) * 1000

  #     # if y + pixels_per_sec * 2 >= (@el.scrollHeight - @el.offsetHeight)
  #       # @collection.request(start: @collection.length, count: 20)
  #       # @$ul.css height: "+=7500px"

  #   @previous_time = time
  #   @previous_y    = y

