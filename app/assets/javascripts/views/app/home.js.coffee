class App.Views.Home extends Backbone.View
  template: JST['templates/app/home']
  id: 'home'

  events:
    'click .authorize': 'authorize'

  initialize: ->

  render: ->
    @$el.html @template()
    this

  authorize: ->
    R.authenticate()

