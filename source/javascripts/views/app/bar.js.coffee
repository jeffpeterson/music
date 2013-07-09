class App.Views.Bar extends Backbone.View
  el: "#bar"

  template: JST['app/bar']

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