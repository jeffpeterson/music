#= require ./show

class App.Views.AlbumExpanded extends Backbone.View
  className: 'expanded-album'

  template: JST['albums/expanded']
  initialize: (options) ->
    @original = options.original

  render: ->
    @track_list or= new App.Views.AlbumTrackIndex collection: @model.track_list
    @colors     or= @model.artwork.colors()
    @model.track_list.lazy_fetch()

    @$el.html @template(album: @model)
    @$el.attr('style', '')

    offset = @original.$el.offset()
    @$el.css
      top:    offset.top - window.scrollY
      left:   offset.left
      width:  @original.$el.width()
      height: @original.$el.height()

    @$('.back').html @track_list.render().el
    @$('ul').css
      backgroundColor: "rgba(#{@colors.background}, 0.9)"
    @render_flip_over()

    @render_click_shield()
    this

  render_flip_over: ->
    setTimeout (=>
      @$el.addClass('expanded')
      @original.$el.addClass('invisible')
      @$el.css
        width: ''
        height: ''
    ), 10
    this

  render_click_shield: ->
    $shield = $("<div>").addClass("click-shield")
    $shield.on 'click', => @remove()
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
    @$el.transit
      # opacity: 0
      duration: 500
      width: @original.$el.width()
      height: @original.$el.height()
      complete: complete


