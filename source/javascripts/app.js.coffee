window.App =
  Views:       {}
  Models:      {}
  Collections: {}

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

  local_set: (key, value) ->
    localStorage[key] = JSON.stringify(value)

  local_get: (key, def = null) ->
    JSON.parse(localStorage[key] || null) || def

  memo: (key, property, value) ->
    cached_object = App.local_get(key, {})
    if value
      cached_object[property] = value
      App.local_set(key, cached_object)
    cached_object[property]

console.time "R.ready"
$(document).ready ->
  App.time "App.initialize"

  R.ready ->
    if not R.authenticated()
      R.authenticate(mode: 'redirect')
    console.timeEnd "R.ready"


