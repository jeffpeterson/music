class App.QueueView extends Backbone.View
  el: "#queue"

  events:
    'dragover':   'dragover'
    'drop':       'drop'
    # 'touchstart': 'touchstart'

  initialize: ->
    @listenTo @collection, "reset", @render
    @listenTo @collection, "add", @render
    @listenTo @collection, "remove", @render
    @listenTo @collection, "change:playingTrack", @render

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

  add: (track) ->
    @$ul.append new App.QueueTrackShow(model: track).render().el

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

