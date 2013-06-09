#= require ./show

class App.PlayerShow extends Backbone.View
  template: JST['player/show']
  el: "#player"

  events:
    'click .pause': -> @model.pause()
    'click .play':  -> @model.play()
    'click .next':  -> @model.next()
    'click .prev':  -> @model.prev()
    'input #volume': 'update_volume'

  initialize: ->
    @model.on "change:playState", @render, this
    @model.on "change:position", @render_position, this
    $(window).on 'keydown', @keypress

    $("#progress").click (event) =>
      event.preventDefault()
      @model.position event.offsetX / $("#progress").width() * 100
      @render_position()

  render: ->
    @$el.html @template()
    @render_volume()
    this

  render_position: =>
    $("#progress .position").css width: @model.position() + "%"

  render_volume: =>
    $("#volume").val(@model.volume())
  
  update_volume: =>
    @model.volume $("#volume").val()

  keypress: (event) =>
    return if event.target isnt document.body
    console.log event

    switch event.which
      when 32
        event.preventDefault()
        @model.toggle()
      when 37#, 38
        event.preventDefault()
        @model.prev()
      when 39#, 40
        event.preventDefault()
        @model.next()
