class App.Router extends Backbone.Router
  routes:
    '': 'index'
    'collection/artists': 'artists'
    'collection/albums': 'albums'
    'collection(/tracks)':    'tracks'

  index: ->
    Backbone.history.navigate "collection", trigger: true

  artists: ->
    if App.collection.artists.isEmpty()
      R.ready => App.collection.artists.fetch()
    new App.ArtistIndexView(collection: App.collection.artists).render()

  albums: ->
    if App.collection.albums.isEmpty()
      R.ready => App.collection.albums.fetch()
    new App.AlbumIndexView(collection: App.collection.albums).render()

  tracks: ->
    if App.collection.tracks.isEmpty()
      R.ready => App.collection.tracks.request(count: 100)
    new App.TrackIndexView(collection: App.collection.tracks).render()

