#= require ./tracks/index
#= require views/items/show

class App.Views.AlbumShow extends App.Views.ItemShow
  tagName:   'li'
  className: 'album'

  template: JST['albums/show']

  events:
    'click':     'expand'
    'dragstart': 'dragstart'

  initialize: ->
    super(arguments...)
    @listenTo @model.artwork, 'change', @render_colors

  render: ->
    unless @model.get("canStream")
      @$el.addClass "unavailable" 
      @$el.attr draggable: false

    @$el.html @template(album: @model)
    @$el.css backgroundImage: "url(#{@model.artwork.get('icon')})"
    this

  expand: (event) ->
    event.preventDefault()
    @render_expanded_view()

  render_expanded_view: ->
    @expanded_view or= new App.Views.AlbumExpanded model: @model, original: this

    $("body").append @expanded_view.render().el
    this
