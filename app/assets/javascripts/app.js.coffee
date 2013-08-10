window.App =
  version: 4

  Views:       {}
  Models:      {}
  Collections: {}
  Routers:     {}

  routers:     {}
  collection:  {}

  debug_on: true
  memo_pad: {}

  initialize: ->
    App.prune_local()

    for name, router of App.Routers
      App.routers[name] = new router

    App.collection.artists   = new App.Collections.Artists
    App.collection.albums    = new App.Collections.Albums
    App.collection.tracks    = new App.Collections.Tracks
    App.collection.playlists = new App.Collections.Playlists

    App.on 'rdio:ready', ->
      App.collection.playlists.fetch()

    App.player = new App.Models.Player
    App.queue  = new App.Models.Queue

    new App.Views.Touch
    new App.Views.Scroll
    new App.Views.Bar().render()
    new App.Views.QueueShow(model: App.queue).render()

    Backbone.history.start pushState: false

  debug: (args...) ->
    console.log("-- DEBUG:", args...) if App.debug_on

  time: (name, fn = eval(name), args...) ->
    console.time name
    fn(args...)
    console.timeEnd name

  set_local: (key, value) ->
    unless value?
      @set_local(k, v) for k, v of key
      return

    localStorage["v#{App.version}/#{key}"] = JSON.stringify(@memo_pad[key] = value)

  get_local: (key, default_value = null) ->
    @memo_pad[key] or= (JSON.parse(localStorage["v#{App.version}/#{key}"] or null) or default_value)

  prune_local: ->
    regex = new RegExp("^v#{App.version}/")
    for key, value of localStorage when not regex.test(key)
      delete localStorage[key]

  memo: (key, property, fn) ->
    cached_object = App.get_local(key, {})
    if fn? and not cached_object[property]
      cached_object[property] = fn?()
      App.set_local(key, cached_object)
    cached_object[property]

_.extend App, Backbone.Events

console.time "R.ready"

window.rdio_loaded = ->
  App.trigger 'rdio:loaded'
  R.ready ->
    App.trigger 'rdio:ready'

$ ->
  App.time "App.initialize"

App.on 'rdio:ready', ->
  if not R.authenticated()
    R.authenticate(mode: 'redirect')
  console.timeEnd "R.ready"

