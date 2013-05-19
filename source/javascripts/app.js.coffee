window.App =
  initialize: ->
    App.router = new App.Router

    App.collection = {}
    App.collection.artists = new App.Artists
    App.collection.albums = new App.Albums
    App.collection.tracks  = new App.Tracks #JSON.parse(localStorage.tracks || '[]')

    App.player = new App.Player
    App.queue  = new App.Queue JSON.parse(localStorage.queue || '[]')

    new App.QueueView(collection: App.queue).render()
    R.ready ->
      new App.PlayerShow(model: App.player).render()

    Backbone.history.start pushState: false

  time: (name, fn = eval(name), args...) ->
    console.time name
    fn(args...)
    console.timeEnd name



console.time "R.ready"
$(document).ready ->
  App.time "App.initialize"

  R.ready ->
    if not R.authenticated()
      R.authenticate(mode: 'redirect')
    console.timeEnd "R.ready"


