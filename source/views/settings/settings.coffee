class App.Views.Settings extends Backbone.View
  template: JST['templates/app/settings']
  id: 'settings'
  className: 'static-page'

  events:
    'click .authorize-sound-cloud': 'authorize_sound_cloud'
    'click .authorize-rdio':        'authorize_rdio'

  initialize: ->
    @listenTo App.adapters.rdio,        'change', @render
    @listenTo App.adapters.sound_cloud, 'change', @render

  render: ->
    @$el.html @template()
    this

  authorize_sound_cloud: ->
    @authorize('sound_cloud')

  authorize_rdio: ->
    @authorize('rdio')

  authorize: (adapter) ->
    App.adapters[adapter].authenticate()

