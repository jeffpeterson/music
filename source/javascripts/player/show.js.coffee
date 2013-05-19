#= require ./show

class App.PlayerShow extends Backbone.View
  template: JST['player/show']
  el: "#player"

  events:
    'click .pause': -> @model.pause()
    'click .play':  -> @model.play()
    'click .next':  -> @model.next()
    'click .prev':  -> @model.prev()

  initialize: ->
    @model.on "change", @render, this
    @model.on "change:position", @render_position, this
    $(window).on 'keypress', @keypress

    $("#progress").click (event) =>
      event.preventDefault()
      @model.position event.offsetX / $("#progress").width() * 100
      @render_position()

  render: ->
    @$el.html @template()
    this

  render_position: =>
    $("#progress .position").css width: @model.position() + "%"

  keypress: (event) =>
    console.log event.which
    switch event.which
      when 32
        @model.toggle()
