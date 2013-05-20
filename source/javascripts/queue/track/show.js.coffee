#= require track/show.js
#= require ./show.jst

class App.QueueTrackShow extends App.TrackView
  template: JST['queue/track/show']
  initialize: ->
    @listenTo @model.collection, "remove", @removed
    @listenTo @model, "current", @current

  events:
    'click .remove': 'remove'
    'click': 'expand'
    'dragstart': 'drag'
    'drop': 'drop'

  render: ->
    @$el.html @template(track: @model)
    @model.set icon: @model.get('icon').replace("square-200", "square-500")

    if @model is App.queue.current_track()
      @$el.attr id: "current-track"

    ImageAnalyzer @model.get('icon'), (bgColor, primaryColor, secondaryColor, detailColor) =>
      @$el.css
        backgroundImage: "-webkit-linear-gradient(top, rgba(#{bgColor}, 1.0) 0px, rgba(#{bgColor}, 0.10) 300px, rgba(#{bgColor}, 0.0) 300px), url(#{@model.get('icon')})"
        textShadow: "0 0 1px rgb(#{bgColor}), 0 0 3px rgb(#{bgColor})"
        color: "rgb(#{primaryColor})"
      @$el.find(".artist-name").css
        color: "rgb(#{secondaryColor})"
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
    # if @$el.hasClass("expanded")
    #   App.queue.play(@model)
    # $("#queue .expanded").removeClass("expanded")
    # @$el.addClass("expanded")

  remove: (event) =>
    event.preventDefault()
    @model.collection.remove @model

  removed: (model) ->
    if model is @model
      @$el.transit
        height: 0
        complete: =>
          @remove()
  current: =>
    @$el.attr id: 'current-track'
