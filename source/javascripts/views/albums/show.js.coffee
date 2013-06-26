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
    is_expanded = @$el.hasClass 'expanded'

    $(".expanded").removeClass 'expanded'
    $(".track-list").remove()
    if not is_expanded
      @$el.parent().addClass('expanded')
      @$el.addClass('expanded')
      @render_track_list()

  render_track_list: ->
    @track_list_view or= new App.Views.AlbumTrackIndex collection: @model.track_list
    @model.track_list.lazy_fetch()

    @first_element_in_next_row().before(@track_list_view.render().el)
    this

  first_element_in_next_row: ->
    offset = @$el.offset().top
    $next = @$el
    $next = $next.next() while $next.offset().top is offset
    $next


