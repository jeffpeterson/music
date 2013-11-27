Component.Album.new 'Modal', parent = Component.Modal,
  events:
    'click .station':       'play_station'
    'click .close':         'remove'
    'click .click-shield':  'remove'
    'click':                'unhighlight'
    'click .view-huge-art': 'viewHugeArt'
    'click .action-menu-button': 'showActionMenu'

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

  render_colors: ->
    @styles.css
      '.album-modal-tracks, .album-modal-tracks .action-menu':
        backgroundColor: "rgb(#{@colors.background})"
        color:           "rgb(#{@colors.secondary})"
      '.cover':
        backgroundImage: "url(#{@model.artwork.get('icon-500')})"
      '.cover:before':
        backgroundImage: "url(#{@model.artwork.get('icon-1200')})"
      '.back, .album-modal-tracks, .album-modal-tracks .track':
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

  showActionMenu: (event) ->
    isInCollection = @model.get('isInCollection')
    offset = $(event.target).offset()

    new Component.ActionMenu
      y: offset.top - $(window).scrollTop()
      x: offset.left - $(window).scrollLeft()
      items: [
        ['Add to Collection',      this.add_to_collection,    !isInCollection]
        ['Remove from Collection', this.removeFromCollection, isInCollection]
      ]

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
