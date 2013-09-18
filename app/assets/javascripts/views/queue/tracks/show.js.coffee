#= require views/tracks/show.js

class App.Views.QueueTrackShow extends App.Views.TrackShow
  template: JST['templates/queue/tracks/show']

  initialize: ->
    @listenTo @model.collection, "remove", @removed
    @listenTo @model, "current", @current
    @listenTo @model, 'change', @render
    @listenTo @model.artwork, 'change', @render_colors

  events:
    'click .remove': 'remove_from_queue'
    'click .text':   'expand'
    dragstart:       'dragstart'
    drop:            'drop'

  render: ->
    @$el.empty()
    @$el.append @template(track: @model)

    if @model is @model.collection.get('current_track')
      @current()

    @render_colors()
    this

  render_colors: ->
    return unless colors = @model.artwork.colors()
    bg = colors.background

    @$el.css
        backgroundImage: "linear-gradient(to top right, rgb(#{bg}), transparent 450px), url(#{@model.artwork.get('icon-500')})"
        color:      "rgb(#{colors.primary})"
        textShadow: "0 1px 0 rgb(#{bg}), 0 -1px 0 rgb(#{bg}), 1px 0 0 rgb(#{bg}), -1px 0 0 rgb(#{bg})"
    @$('.artist-name').css
        color:      "rgb(#{colors.secondary})"

  play: (event) ->
    event.preventDefault()
    App.queue.play(@model)

  drop: (event) =>
    event.preventDefault()

    data = event.originalEvent.dataTransfer.getData("text/json")
    @model.collection.add JSON.parse(data),
      at: @model.collection.indexOf(@model)

  expand: (event) =>
    event.preventDefault()
    App.queue.play(@model)

  remove_from_queue: =>
    @model.collection.remove @model

  removed: (model) ->
    return if model isnt @model

    @$el.transit
      height: 0
      duration: 500
      complete: => @remove()

  current: =>
    @$el.attr id: 'current-track'
    @$el.addClass 'sticky'
