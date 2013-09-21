class App.Component.Header extends App.Component
  el: "#bar"

  template: JST['']

  events:
    'input #search': 'search'

  initialize: ->
    @listenTo Backbone.history, 'route', @render_current_path
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

  search: (event) ->
    App.trigger('search', event.target.value)
