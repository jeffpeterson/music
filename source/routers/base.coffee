class App.Routers.Base extends BetterRouter
  routes:
    'home':     'home'
    'settings': 'settings'

  initialize: ->
    @el = '#content'
    super(arguments...)

  home: ->
    @swap new App.Views.Home

  settings: ->
    @swap new App.Views.Settings
