class App.Views.ProgressBarShow extends Backbone.View
  el: "#progress"
  events:
    click: (event) =>
      @model.position event.offsetX / @$el.width() * 100
      @render()

  initialize: ->
    @model.on "change:position", @render, this

  render: =>
    @$('.position').css width: @model.position() + "%"
    this
