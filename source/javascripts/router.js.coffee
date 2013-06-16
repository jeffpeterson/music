class App.Router extends BetterRouter
  routes:
    '': 'index'
    'collection/artists':  'artists'
    'collection/albums':   'albums'
    'collection(/tracks)': 'tracks'

  initialize: ->
    @el = '#content'

  index: ->
    Backbone.history.navigate "collection/tracks", trigger: true

  artists: ->
    @swap new App.ArtistIndexView(collection: App.collection.artists)
    R.ready => App.collection.artists.fetch start: 0

  albums: ->
    @swap new App.AlbumIndexView(collection: App.collection.albums)
    R.ready => App.collection.albums.fetch start: 0

  tracks: ->
    @swap new App.TrackIndexView(collection: App.collection.tracks)
    R.ready => App.collection.tracks.fetch start: 0

