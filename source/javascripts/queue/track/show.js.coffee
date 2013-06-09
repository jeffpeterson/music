#= require track/show.js
#= require ./show.jst

class App.QueueTrackShow extends App.TrackView
  template: JST['queue/track/show']
  initialize: ->
    @listenTo @model.collection, "remove", @removed
    @listenTo @model, "current", @current

  events:
    'click .remove': 'remove'
    'click .text': 'expand'
    'dragstart': 'drag'
    'drop': 'drop'

  render: ->
    @$el.html @template(track: @model)
    @model.set icon: @model.get('icon').replace("square-200", "square-500")

    if @model is App.queue.current_track()
      @$el.attr id: "current-track"

    ImageAnalyzer.analyze @model.get('icon'), (colors) =>
      bg = colors.background
      @$el.css
        backgroundImage: "-webkit-linear-gradient(top, rgba(#{bg}, 1.0) 0px, rgba(#{bg}, 0.10) 300px, rgba(#{bg}, 0.0) 300px), url(#{@model.get('icon')})"
        textShadow: "0 0 3px rgb(#{bg})"
        color: "rgb(#{colors.primary})"
      @$el.find(".artist-name").css
        color: "rgb(#{colors.secondary})"
    this

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

  remove: (event) =>
    event.preventDefault()
    @model.collection.remove @model

  removed: (model) ->
    return if model isnt @model

    @$el.transit
      height: 0
      complete: =>
        @remove()
  current: =>
    @$el.attr id: 'current-track'
    try
      $("#queue").scrollTo "#current-track",
        duration: 500
        offset:
          top: -300
