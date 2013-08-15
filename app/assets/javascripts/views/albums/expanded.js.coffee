class App.Views.AlbumExpanded extends Backbone.View
  className: 'modal'

  events:
    'click .station':      'play_station'
    'click .close':        'remove'
    'click .click-shield': 'remove'

  template: JST['templates/albums/expanded']

  initialize: (options) ->
    @original = options.original
    @$el.removeClass('is-expanded') if @original

  render: ->
    @delegateEvents()
    @styles     or= new App.Views.Style
    @track_list or= new App.Views.AlbumTrackIndex collection: @model.track_list
    @colors       = @model.artwork.get('colors')
    @model.track_list.lazy_fetch()

    @render_colors()

    @$el.html   @styles.render().el
    @$el.append @template(album: @model)
    @$el.attr(style: '')

    @$('.back').append @track_list.render().el

    @render_click_shield()
    this

  in: ->
    @move_to_original()
    @flip_over()

  move_to_original: ->
    return unless @original

    offset = @original.$el.offset()
    width  = @original.$el.width()
    scale  = width / 500
    y      = offset.top - window.scrollY# - (500 - width) / 2
    x      = offset.left# - (500 - width) / 2

    @$el.css
      webkitTransform: "scale(#{scale})"
      left: x
      top: y

  render_colors: ->
    @styles.css
      '.cover, .card':
        'background-image': "url(#{@model.artwork.get('icon-500')})"
      # '.card':
      #   'background-image': "linear-gradient(to left, rgb(#{@colors.background}), rgba(#{@colors.background}, 0.01)),
      #     url(#{@model.artwork.get('icon-500')})"
      '.back, .track-list':
        'background-color': "rgba(#{@colors.background}, 1)"
        color:              "rgb(#{@colors.secondary})"
      '.album-name':
        color: "rgba(#{@colors.primary}, 1.0)"
      '.artist-name, .release-date':
        color: "rgba(#{@colors.primary}, 0.5)"
      'button, button:active, i':
        color: "rgb(#{@colors.detail})"
      '.track:hover':
        backgroundColor: "rgba(#{@colors.contrast}, 0.5)"
    this

  flip_over: ->
    requestAnimationFrame =>
      @$el.addClass('is-expanded')
      @original?.$el.addClass('invisible')
      @$el.attr(style: '')

  render_click_shield: ->
    $("body").addClass('freeze')
    this

  remove: ->
    super(arguments...)
    App.go 'collection/albums', trigger: false
    $('body').removeClass('freeze')
    @original?.$el.removeClass('invisible')

  out: (complete) ->
    @$el.transit
      opacity: 0,
      complete: complete

  play_station: (event) ->
    event.preventDefault()
    R.player.play source: 'r' + @model.get('rawArtistKey') + '|3'
