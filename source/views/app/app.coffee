window.App or= {}

module.exports = 1

App.version = 5

App.Views       = {}
App.Adapters    = {}
App.Models      = {}
App.Collections = {}

App.adapters   = {}
App.collection = {}
App.catalog    = {}

App.debug_on = true
App.memo_pad = {}

App.initialize = ->
  App.store.clear()

  App.router = new App.Router

  App.collection.artists        = new App.Collections.Artists
  App.collection.albums         = new App.Collections.Albums
  App.collection.tracks         = new App.Collections.Tracks
  App.collection.playlists      = new App.Collections.Playlists
  App.collection.heavy_rotation = new App.Collections.HeavyRotation

  App.catalog.top_charts   = new App.Collections.TopCharts
  App.catalog.new_releases = new App.Collections.NewReleases

  App.player = new App.Models.Player
  App.queue  = new App.Models.Queue

  new App.Views.Touch
  new App.Views.Scroll
  new App.Views.Drag
  new Component.Header().render()
  new Component.Queue(model: App.queue).render()
  new Component.WindowTitle().render()

  App.adapters.rdio.on 'change:isAuthenticated', (authed) ->
    App.go 'top-charts' unless authed

  Backbone.history.start pushState: false

App.history = []
App.go = (fragment, options = {}) ->
  _.defaults options, trigger: true
  if match = fragment.match /back:?(.*)/
    if url = App.history.pop()
      Backbone.history.navigate url, options
    else
      App.go(match[1] or 'collection', options)
  else
    App.history.push Backbone.history.fragment
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

  App.go 'top-charts' unless R.authenticated()
