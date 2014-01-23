Component.Queue.new 'Track', ->
  @superClass App.Views.TrackShow

  @events
    'click .remove': 'remove_from_queue'
    'click .text':   'expand'
    dragstart:       'dragstart'
    drop:            'drop'


  # @state 'resting', 'removed', ->
  # @state.from('resting').tap (resting) ->
  #   resting.to 'removed', ->
  #   resting.to 'current', ->
  #     @$el.addClass('current')

  # @state.start 'resting', 'loggedIn'

  # @state.go 'removed'



  @extras
    initialize: ->
      _.bindAll this, 'current', 'remove_from_queue', 'drop', 'expand'
      @listenTo App.queue.tracks, "remove", @removed
      @listenTo @model, "current", @current
      @listenTo @model, 'change', @render
      @listenTo @model.artwork, 'change', @renderColors

    render: ->
      @$el.empty()
      @$el.append @template(track: @model)

      if @model is @model.collection.get('current_track')
        @current()

      @renderColors()
      this

    renderBlur: ->
      @model.artwork.blur (url) =>
        @$('.blur').css
          backgroundImage: "url('#{url}')"

        @$('.shadow').css
          backgroundColor: "rgba(#{@colors.background}, 0.8)"

    renderColors: ->
      return unless @colors = @model.artwork.colors()
      bg = @colors.background

      @$el.css
        backgroundImage: "url(#{@model.artwork.get('icon-500')})"
        color:           "rgb(#{@colors[0]})"

      @$('.shadow').css
        backgroundColor: "rgb(#{bg})"

      @$('.artist-name').css
        color: "rgb(#{@colors[1]})"

      @renderBlur()

    play: (event) ->
      event.preventDefault()
      App.queue.play(@model)

    drop: (event) ->
      event.preventDefault()

      data = event.originalEvent.dataTransfer.getData("text/json")
      @model.collection.add JSON.parse(data),
        at: @model.collection.indexOf(@model)

    expand: (event) ->
      event.preventDefault()
      App.queue.play(@model)

    remove_from_queue: ->
      App.queue.tracks.remove @model

    removed: (model) ->
      return if model isnt @model

      @$el.transit
        height: 0
        duration: 500
        complete: => @remove()

    current: ->
      @$el.attr id: 'current-track'
      @$el.addClass 'sticky'
