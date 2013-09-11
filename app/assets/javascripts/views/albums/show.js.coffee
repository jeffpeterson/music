#= require ./tracks/index
#= require views/items/show

class App.Views.AlbumShow extends App.Views.ItemShow
  tagName:   'li'
  className: 'album'

  template: JST['templates/albums/show']

  events:
    'click':     'show'
    'dragstart': 'dragstart'

  initialize: ->
    super(arguments...)
    @listenTo @model.artwork, 'change', @render_colors

  render: ->
    super()
    unless @model.get("canStream")
      @$el.addClass "unavailable" 
      @$el.attr draggable: false

    @$el.html @template(album: @model)
    @$el.css backgroundImage: "url(#{@model.artwork.get('icon')})"
    this

  show: (event) ->
    event.preventDefault()

    view = new App.Views.AlbumExpanded model: @model, original: this
    view.render().in()
    $("body").append view.el

    App.go @model.get('route'), trigger: false
