#= require ./show

class App.Views.AlbumExpanded extends Backbone.View
  className: 'expanded-album'

  events:
    'click .station': 'play_station'

  template: JST['albums/expanded']
  initialize: (options) ->
    @original = options.original

  render: ->
    @styles     or= new App.Views.Style
    @track_list or= new App.Views.AlbumTrackIndex collection: @model.track_list
    @colors       = @model.artwork.get('colors')
    @model.track_list.lazy_fetch()

    @render_colors()

    @$el.html   @styles.render().el
    @$el.append @template(album: @model)
    @$el.attr(style: '')

    offset = @original.$el.offset()
    @$el.css
      top:    offset.top - window.scrollY
      left:   offset.left
      width:  @original.$el.width()
      height: @original.$el.height()

    @$('.back').append @track_list.render().el

    @render_flip_over()
    @render_click_shield()
    this

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
      'button:active, .station:hover':
        color: "rgb(#{@colors.detail})"
      '.station':
        color: "rgba(#{@colors.detail}, 0.6)"
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
      @original.$el.removeClass('invisible')
      $('body').removeClass('freeze')
      $(".click-shield").remove()
    this

  out: (complete) ->
    $(".click-shield").transit opacity: 0
    @$el.removeClass('expanded')
    offset = @original.$el.offset()
    @$el.transit
      duration: 700
      width: @original.$el.width()
      height: @original.$el.height()
      top:    offset.top - window.scrollY
      left:   offset.left
      complete: complete

  play_station: (event) ->
    event.preventDefault()
    R.player.play source: 'r' + @model.get('rawArtistKey') + '|3'


