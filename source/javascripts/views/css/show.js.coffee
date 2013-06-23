class App.Views.CssShow extends Backbone.View
  tagName: 'style'

  attributes:
    media: 'screen'
    type: 'text/css'

  template: JST['css/show']

  initialize: ->
    @listenTo App.queue, 'change:current_track', @render

  render: ->
    @$el.html @template(App.queue.get('current_track').artwork.colors())
    this
