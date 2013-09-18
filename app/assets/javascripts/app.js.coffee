window.App or= {}

App.version = 5

App.Views       = {}
App.Adapters    = {}
App.Models      = {}
App.Collections = {}
App.Routers     = {}

App.adapters   = {}
App.routers    = {}
App.collection = {}

App.debug_on = true
App.memo_pad = {}

App.initialize = ->
  App.store.clear()

  for name, router of App.Routers
    App.routers[name] = new router

  App.collection.artists        = new App.Collections.Artists
  App.collection.albums         = new App.Collections.Albums
  App.collection.tracks         = new App.Collections.Tracks
  App.collection.playlists      = new App.Collections.Playlists
  App.collection.heavy_rotation = new App.Collections.HeavyRotation

  App.collection.playlists.fetch(start: 0)

  App.player = new App.Models.Player
  App.queue  = new App.Models.Queue

  new App.Views.Touch
  new App.Views.Scroll
  new App.Views.Drag
  new App.Views.Bar().render()
  new App.Views.QueueShow(model: App.queue).render()

  Backbone.history.start pushState: false

App.go = (fragment, options = {}) ->
  _.defaults options, trigger: true
  Backbone.history.navigate fragment, options

App.debug = (args...) ->
  console.log("-- DEBUG:", args...) if App.debug_on

App.time = (name, fn = eval(name), args...) ->
  console.time name
  fn(args...)
  console.timeEnd name


_.extend App, Backbone.Events

console.time "R.ready"

$ ->
  App.time "App.initialize"

App.on 'rdio:ready', ->
  console.timeEnd "R.ready"
  App.store.set current_user: R.currentUser
  App.go 'home' if not R.authenticated()
