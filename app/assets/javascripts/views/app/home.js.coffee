class App.Views.Home extends Backbone.View
  template: JST['templates/app/home']
  id: 'home'
  className: 'static-page'

  events:
    'click .authorize': 'authorize'

  initialize: ->

  render: ->
    @$el.html @template()
    this

  authorize: ->
    R.authenticate()

