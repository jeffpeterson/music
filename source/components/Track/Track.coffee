Component.new 'Track', App.Views.ItemShow,
  tagName: 'li'

  initialize: (options) ->
    @sup::initialize?.apply(this, arguments)

  events:
    'click .play-now':          'playNow'
    'click .album-art':         'playNow'
    'click .add-to-queue':      'addToQueue'
    'click .add-to-collection': 'addToCollection'
    'dragstart':                'dragstart'

  render: ->
    unless @model.get("canStream")
      @$el.addClass "unavailable"
      @$el.attr draggable: false

    @$el.html @template(track: @model)
    this

  playNow: (event) ->
    if @playNext(event)
      App.queue.play(@model)

  playNext: (event) ->
    return unless @model.get('canStream')

    App.queue.tracks.add(@model, at: App.queue.current_index(1))
    return this


  addToQueue: ->
    return unless @model.get('canStream')

    App.queue.tracks.add @model

  highlight: (event) ->
    event.preventDefault()

    requestAnimationFrame =>
      @$el.addClass('is-highlighted')
