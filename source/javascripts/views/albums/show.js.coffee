#= require ./tracks/index

class App.Views.AlbumShow extends Backbone.View
  tagName: "li"
  className: "album"

  template: JST['albums/show']

  events:
    click: 'expand'

  initialize: ->
    @listenTo @model.artwork, 'change', @render_colors
    @listenTo @model, 'remove', @remove

    @$el.css backgroundImage: "url(#{@model.artwork.get('icon')})"

  render: ->
    unless @model.get("canStream")
      @$el.addClass "unavailable" 
      @$el.attr draggable: false

    @$el.html @template(album: @model)
    this

  expand: (event) ->
    event.preventDefault()
    @render_expanded_view()

  render_expanded_view: ->
    @expanded_view or= new App.Views.AlbumExpanded model: @model, original: this

    $("body").append @expanded_view.render().el
    this
