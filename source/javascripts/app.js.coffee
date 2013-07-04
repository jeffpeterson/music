window.App =
  Views:       {}
  Models:      {}
  Collections: {}

  debug_on: true
  memo_pad: {}

  initialize: ->
    App.router = new App.Router

    App.collection = {}
    App.collection.artists = new App.Collections.Artists
    App.collection.albums  = new App.Collections.Albums
    App.collection.tracks  = new App.Collections.Tracks

    App.player = new App.Models.Player
    App.queue  = new App.Models.Queue

    new App.Views.Touch
    new App.Views.Scroll
    new App.Views.QueueShow(model: App.queue).render()
    new App.Views.PlayerShow(model: App.player).render()

    Backbone.history.start pushState: false

  debug: (args...) ->
    console.log("-- DEBUG:", args...) if App.debug_on

  time: (name, fn = eval(name), args...) ->
    console.time name
    fn(args...)
    console.timeEnd name

  set_local: (key, value) ->
    if value
      attrs = {}
      attrs[key] = value
    else
      attrs = key

    for key, value of attrs
      localStorage[key] = JSON.stringify(value)

  get_local: (key, default_value = null) ->
    JSON.parse(localStorage[key] or null) or default_value

  memo: (key, property, fn) ->
    cached_object = App.get_local(key, {})
    if fn? and not cached_object[property]
      cached_object[property] = fn?()
      App.set_local(key, cached_object)
    cached_object[property]
_.extend App, Backbone.Events

$(document).ready ->
  App.time "App.initialize"

  R.ready ->
    if not R.authenticated()
      R.authenticate(mode: 'redirect')
    console.timeEnd "R.ready"
