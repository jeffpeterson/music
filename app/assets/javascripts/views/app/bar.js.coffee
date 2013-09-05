class App.Views.Bar extends Backbone.View
  el: "#bar"

  template: JST['templates/app/bar']

  events:
    'input #search': 'search'

  initialize: ->
    @listenTo Backbone.history, 'route', @render_current_path
    @listenTo App.queue, 'change:current_track', @render_background
    @$el.html @template()
    @player_view = new App.Views.PlayerShow(model: App.player)
    @player_view.render()

  render: ->
    @render_current_path()
    this

  render_current_path: ->
    fragment = Backbone.history.getHash()
    @$('a.current').removeClass('current')
    @$("a[href='##{fragment}']").addClass('current')
    this

  render_background: (current_track) ->
    canvas = document.createElement('canvas')
    canvas.height = @$el.height()
    canvas.width  = @$el.width()
    canvas.blur 100, src: App.queue.get('current_track').get('icon'), done: (canvas) =>
      @$el.css backgroundImage: "url(#{canvas.toDataURL()})"

  search: (event) ->
    App.trigger('search', event.target.value)
