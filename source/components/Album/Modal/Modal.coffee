Component.Album.new 'Modal', parent = Component.Modal,
  events:
    'click .station':       'play_station'
    'click .close':         'remove'
    'click .click-shield':  'remove'
    'click':                'unhighlight'
    'click .view-huge-art': 'viewHugeArt'
    'click .action-menu-button': 'showActionMenu'
    'scroll .modal-inner':  'onScroll'

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
    @scroller   = @$(".scroller")[0]
    @blur       = @$(".blur")[0]
    @back       = @$(".back")[0]

    @ticking = false
    @onScrollTick = @onScrollTick.bind(this)

    @scroller.addEventListener 'scroll', @onScroll.bind(this), false

    @render_click_shield()
    @renderBlur()
    this

  render_colors: ->
    @styles.css
      '.album-modal':
        '.album-modal-tracks':
          color: "rgb(#{@colors[1]})"
        '.shadow, .blur, .modal-inner, .back':
          backgroundColor: "rgb(#{@colors.background})"
        '.modal-inner':
          backgroundImage: "url(#{@model.artwork.get('icon-1200')}), url(#{@model.artwork.get('icon-500')})"
        '.album-name':
          color: "rgb(#{@colors[0]})"
        '.artist-name, .release-date':
          color: "rgb(#{@colors[0]})"
        'button, button:active, i':
          color: "rgb(#{@colors[2]})"
    this

  renderBlur: ->
    @model.artwork.blur (url) =>
      @$(".shadow").addClass 'translucent'
      $(@scroller).scrollTo("100%", 800)
      @styles.css
        '.album-modal':
          '.blur':
            backgroundImage: "url('#{url}')"
      @styles.render()
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

  onScroll: (e) ->
    if not @ticking
      @ticking = true
      requestAnimationFrame @onScrollTick

  onScrollTick: ->
    @ticking = false

    scrollTop = @scroller.scrollTop
    @blur.style.backgroundPosition = "center #{scrollTop}px"

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

  play_station: (event) ->
    event.preventDefault()
    R.player.play source: 'r' + @model.get('rawArtistKey') + '|3'

  unhighlight: (event) ->
    event.preventDefault()
    @$('.is-highlighted').removeClass('is-highlighted')

  viewHugeArt: (event) ->
    window.open @model.artwork.get('icon-1200')
