class App.Routers.Base extends BetterRouter
  routes:
    'home': 'home'

  initialize: ->
    @el = '#content'
    super(arguments...)

  home: ->
    @swap new App.Views.Home

