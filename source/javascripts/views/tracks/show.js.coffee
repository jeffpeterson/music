class App.TrackView extends Backbone.View
  tagName: "li"
  className: "track"
  attributes:
    draggable: true

  template: JST['tracks/show']

  events:
    'click .play':      "play"
    'click .album-art': "play"
    'click .queue':     "queue"
    'dragstart':        "drag"

  render: ->
    unless @model.get("canStream")
      @$el.addClass "unavailable" 
      @attributes.draggable = null

    @$el.html @template(track: @model)
    this

  play: (event) =>
    event.preventDefault()
    App.queue.tracks.add(@model, at: App.queue.relative(1))
    App.queue.play(@model)

  queue: (event) ->
    event.preventDefault()
    App.queue.tracks.add @model

  drag: (event) ->
    event.originalEvent.dataTransfer.setData "text/json", JSON.stringify(@model)
    event.originalEvent.dataTransfer.setData "text/plain", @model.full()
