class App.AlbumView extends Backbone.View
  tagName: "li"
  className: "album"
  attributes:
    draggable: true

  template: JST['albums/show']

  initialize: ->
    @listenTo @model.artwork, 'change', @render_colors

  render: ->
    @$el.html @template(album: @model)
    @render_colors()
    this

  render_colors: ->
    return unless colors = @model.artwork.colors()
    @$(".album-art").addClass 'invisible'

    bg = colors.background
    @$el.css
      backgroundImage: "linear-gradient(to top, rgb(#{bg}), rgba(#{bg}, 0.8) 30%, rgba(#{bg}, 0) 80%), url(#{@model.artwork.get('icon')})"
      textShadow: "0 0 3px rgb(#{bg})"
      color: "rgb(#{colors.primary})"
    @$el.find(".artist-name").css
      color: "rgb(#{colors.secondary})"

