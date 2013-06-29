#= require ./tracks/index

class App.Views.AlbumShow extends Backbone.View
  tagName: "li"
  className: "album"

  template: JST['albums/show']

  events:
    click: 'expand'

  initialize: ->
    @listenTo @model.artwork, 'change', @render_colors
    @$el.css backgroundImage: "url(#{@model.artwork.get('icon')})"

  render: ->
    @$el.html @template(album: @model)
    this

  expand: (event) ->
    event.preventDefault()
    @render_track_list()

  render_track_list: ->
    @expanded_view or= new App.Views.AlbumExpanded model: @model
    $el = @expanded_view.render().$el
    offset = @$el.offset()
    $el.css
      top:   offset.top# - window.scrollY
      left:  offset.left
      right: 'auto'
      width: @$el.width()
      height: @$el.height()

    $("body").append $el
    setTimeout (->
      $el.addClass('expanded')
      $el.css
        width: ''
        height: ''
    ), 10
    this
