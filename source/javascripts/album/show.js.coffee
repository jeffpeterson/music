#= require ./show

class App.AlbumView extends Backbone.View
  tagName: "li"
  className: "album"
  attributes:
    draggable: true

  template: JST['album/show']

  events:
    'click': 'click'
  #   'dragstart':        "drag"

  initialize: ->
    # @model.set icon: @model.get('icon').replace("square-200", "square-500")

  render: ->
    @$el.html @template(album: @model)

    # ImageAnalyzer @model.get('icon'), (bgColor, primaryColor, secondaryColor, detailColor) =>
    #   @$el.find(".text").css
    #     backgroundImage: "linear-gradient(to top, rgb(#{bgColor}), transparent)"
    #     color: "rgb(#{primaryColor})"

    this
  click: (event) ->
    # @$el.find(".album-art").transit(scale: 3, zIndex: 10)

  # drag: (event) ->
  #   event.originalEvent.dataTransfer.setData "text/json", JSON.stringify(@model)
  #   event.originalEvent.dataTransfer.setData "text/plain", @model.full()

