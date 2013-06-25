class App.Views.PlayerShow extends Backbone.View
  template: JST['player/show']
  el: "#player"

  events:
    'click .pause': (e) -> e.preventDefault(); @model.pause()
    'click .play':  (e) -> e.preventDefault(); @model.play()
    'click .next':  (e) -> e.preventDefault(); @model.next()
    'click .prev':  (e) -> e.preventDefault(); @model.prev()
    'input #volume': 'update_volume'

  initialize: ->
    @model.on "change:playState", @render, this
    $(window).on 'keydown', @keypress

  render: ->
    @$el.html @template()
    @render_volume()
    new App.Views.ProgressBarShow(model: @model).render()
    this

  render_volume: =>
    $("#volume").val @model.volume()

  update_volume: =>
    @model.volume $("#volume").val()

  keypress: (event) =>
    console.log event
    return if event.target isnt document.body

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
