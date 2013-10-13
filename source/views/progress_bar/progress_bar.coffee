class App.Views.ProgressBarShow extends Backbone.View
  el: "#progress"
  events:
    click: (event) ->
      App.debug "Click at offsetX:", event.offsetX
      @model.set_position event.offsetX / @$el.width()
      @render()

  initialize: ->
    @model.on "change:position", @render, this

  render: =>
    @$('.position').css width: @model.get('position') * 100 + "%"
    this
