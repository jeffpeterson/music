class App.QueueView extends Backbone.View
  el: "#queue"

  events:
    'dragover':   'dragover'
    'drop':       'drop'

  initialize: ->
    @listenTo @collection, "reset", @render
    @listenTo @collection, "add", @add
    @listenTo @collection, "change:playingTrack", @change_playing_track

  render: ->
    @$ul = $("<ul>")
    @previous_icon = null

    @collection.each (track) =>
      @add track

    @$el.html @$ul
    try
      @$el.scrollTo ".current-track",
        duration: 500
        offset:
          top: -75
    this

  add: (track, queue) ->
    $el = new App.QueueTrackShow(model: track).render().el
    @$ul.append $el

  change_playing_track: ->
    $("#current-track").removeAttr("id")
    @collection.current_track().trigger("current")

  dragover: (event) ->
    dt = event.originalEvent.dataTransfer
    event.preventDefault() if _.contains(dt.types, "text/json")

  drop: (event) =>
    event.preventDefault()

    data = event.originalEvent.dataTransfer.getData("text/json")
    App.queue.add JSON.parse(data)
  # touchstart: (event) =>
  #   @$el.scrollTo("+=1")
  #   @$el.scrollTo("-=1")

