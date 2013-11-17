#= require views/items/show

class App.Views.TrackShow extends App.Views.ItemShow
  tagName: 'li'
  className: 'track'

  template: JST['templates/tracks/show']

  initialize: (options) ->
    super()
    _.bindAll this, 'play_now', 'add_to_queue', 'playNext'


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

  play_now: (event) ->
    if @playNext(event)
      App.queue.play(@model)

  playNext: (event) ->
    return unless @model.get('canStream')

    App.queue.tracks.add(@model, at: App.queue.current_index(1))
    return this


  add_to_queue: ->
    return unless @model.get('canStream')

    App.queue.tracks.add @model

  highlight: (event) ->
    event.preventDefault()

    requestAnimationFrame =>
      @$el.addClass('is-highlighted')


