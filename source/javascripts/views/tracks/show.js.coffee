class App.Views.TrackShow extends Backbone.View
  tagName: "li"
  className: "track"
  attributes:
    draggable: true

  template: JST['tracks/show']

  initialize: ->
    @listenTo @model, 'change', @render

  events:
    'click .play-now':          'play_now'
    'click .album-art':         'play_now'
    'click .add-to-queue':      'add_to_queue'
    'click .add-to-collection': 'add_to_collection'
    'dragstart':                'dragstart'

  render: ->
    unless @model.get("canStream")
      @$el.addClass "unavailable" 
      @$el.attr draggable: false

    @$el.html @template(track: @model)
    this

  play_now: (event) =>
    event.preventDefault()
    event.stopPropagation()

    return unless @model.get('canStream')

    App.queue.tracks.add(@model, at: App.queue.current_index(1))
    App.queue.play(@model)

  add_to_queue: (event) ->
    event.preventDefault()
    event.stopPropagation()

    return unless @model.get('canStream')

    App.queue.tracks.add @model

  add_to_collection: (event) ->
    event.preventDefault()
    event.stopPropagation()

    @model.add_to_collection()

  dragstart: (event) ->
    event.originalEvent.dataTransfer.setData "text/json", JSON.stringify(@model)
    event.originalEvent.dataTransfer.setData "text/plain", @model.full()
