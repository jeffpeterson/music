class App.Views.AlbumExpanded extends Backbone.View
  className: 'expanded-album'

  events:
    'click .station': 'play_station'
    'click .close':   'remove'

  template: JST['templates/albums/expanded']
  initialize: (options) ->
    @original = options.original

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

    @move_to_original()

    @$('.back').append @track_list.render().el

    @render_flip_over()
    @render_click_shield()
    this

  move_to_original: ->
    offset = @original.$el.offset()
    width  = @original.$el.width()
    scale  = width / 500
    y      = offset.top - window.scrollY - (500 - width) / 2
    x      = offset.left - (500 - width) / 2

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
      '.back':
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

  render_flip_over: ->
    setTimeout (=>
      @$el.addClass('expanded')
      @original.$el.addClass('invisible')
      @$el.attr(style: '')
    ), 10
    this

  render_click_shield: ->
    $shield = $("<div>").addClass("click-shield")
    $shield.one 'click', => @remove()
    $("body").addClass('freeze').append($shield)
    this

  remove: ->
    @out =>
      super()
      $('body').removeClass('freeze')
      @original.$el.removeClass('invisible')
      $(".click-shield").remove()
    this

  out: (complete) ->
    $(".click-shield").transit opacity: 0
    @$el.removeClass('expanded')
    @move_to_original()
    setTimeout(complete, parseFloat(@$('.card').css("transition").split(' ')[1]) * 1000)

  play_station: (event) ->
    event.preventDefault()
    R.player.play source: 'r' + @model.get('rawArtistKey') + '|3'


