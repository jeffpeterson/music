class App.Views.AlbumShow extends Backbone.View
  tagName: "li"
  className: "album"

  template: JST['albums/show']

  events:
    click: 'expand'

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

  expand: (event) ->
    event.preventDefault()

    is_expanded = @$el.hasClass('expanded')

    $(".expanded").removeClass("expanded")

    @hide_track_list()
    if not is_expanded
      @$el.parent().addClass('expanded')
      @$el.addClass('expanded')
      @render_track_list()

  render_track_list: ->
    @track_list_view or= new App.Views.AlbumTrackIndex collection: @model.track_list
    @model.track_list.lazy_fetch()

    @first_element_in_next_row().before(@track_list_view.render().el)
    this

  hide_track_list: -> $(".track-list").remove()

  first_element_in_next_row: ->
    offset = @$el.offset().top
    $next = @$el
    $next = $next.next() while $next.offset().top is offset
    $next


