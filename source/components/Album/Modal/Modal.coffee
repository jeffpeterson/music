Component.Album.new 'Modal', parent = Component.Modal,
  events:
    'click .station':       'play_station'
    'click .close':         'remove'
    'click .click-shield':  'remove'
    'click':                'unhighlight'
    'click .view-huge-art': 'viewHugeArt'

  initialize: (options) ->
    @original = options.original
    @$el.removeClass('is-expanded') if @original

  render: ->
    @delegateEvents()
    @styles     or= new App.Views.Style
    @tracks     or= new Component.Album.Modal.Tracks collection: @model.track_list
    @colors       = @model.artwork.get('colors')
    @model.track_list.lazy_fetch()

    @render_colors()

    @$el.html   @styles.render().el
    @$el.append @template(album: @model)
    @$el.attr(style: '')

    @$('.content').append @tracks.render().el

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
      '.modal .album, .modal .album .action-menu':
        backgroundColor: "rgb(#{@colors.background})"
        color:           "rgb(#{@colors.secondary})"
      '.cover':
        backgroundImage: "url(#{@model.artwork.get('icon-1200')})"
      '.back, .modal .tracks, .modal .track':
        backgroundColor: "rgb(#{@colors.background})"
      '.modal .album-name':
        color: "rgb(#{@colors.primary})"
      '.modal .artist-name, .modal .release-date':
        color: "rgb(#{@colors.primary})"
      '.modal button, .modal button:active, i':
        color: "rgb(#{@colors.detail})"
      '.modal .track.is-highlighted, .modal .track.is-highlighted:hover, .modal .album .action-menu li:hover':
        backgroundColor: "rgb(#{@colors.detail})"
      '.modal .track:hover':
        color: "rgb(#{@colors.detail})"
      '.modal .track.is-highlighted, .modal .track.is-highlighted i, .modal .track.is-highlighted button, .modal .album .action-menu li:hover':
        color: "rgb(#{@colors.background})"
    this

  flip_over: ->
    requestAnimationFrame =>
      @$el.addClass('is-expanded')
      @$el.attr(style: '')

  render_click_shield: ->
    $("body").addClass('freeze')
    $("#main").addClass('blur')
    this

  remove: ->
    $('body').removeClass('freeze')
    $("#main").removeClass('blur')
    App.go 'back:collection', trigger: false
    @out =>
      parent::remove.apply(this, arguments)

  out: (complete) ->
    @$el.transit
      opacity: 0,
      complete: complete

  play_station: (event) ->
    event.preventDefault()
    R.player.play source: 'r' + @model.get('rawArtistKey') + '|3'

  unhighlight: (event) ->
    event.preventDefault()
    @$('.is-highlighted').removeClass('is-highlighted')

  viewHugeArt: (event) ->
    window.open @model.artwork.get('icon-1200')
