window.App =
  Views:       {}
  Models:      {}
  Collections: {}

  memo_pad: {}

  initialize: ->
    App.router = new App.Router

    App.collection = {}
    App.collection.artists = new App.Artists JSON.parse(localStorage.artists || null)
    App.collection.albums  = new App.Albums JSON.parse(localStorage.albums || null)
    App.collection.tracks  = new App.Tracks JSON.parse(localStorage.tracks || null)

    App.player = new App.Player
    App.queue  = new App.Models.Queue
    # $("body").append new App.Views.CssShow().render().el

    new App.Views.QueueShow(model: App.queue).render()
    R.ready ->
      new App.PlayerShow(model: App.player).render()

    Backbone.history.start pushState: false

  time: (name, fn = eval(name), args...) ->
    console.time name
    fn(args...)
    console.timeEnd name

  set_local: (key, value) ->
    localStorage[key] = JSON.stringify(value)

  get_local: (key, default_value = null) ->
    JSON.parse(localStorage[key] or null) or default_value

  memo: (key, property, fn) ->
    cached_object = App.get_local(key, {})
    if fn? and not cached_object[property]
      cached_object[property] = fn?()
      App.set_local(key, cached_object)
    cached_object[property]

console.time "R.ready"
$(document).ready ->
  App.time "App.initialize"

  R.ready ->
    if not R.authenticated()
      R.authenticate(mode: 'redirect')
    console.timeEnd "R.ready"


