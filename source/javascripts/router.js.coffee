class App.Router extends BetterRouter
  routes:
    '': 'index'
    'collection/artists':  'artists'
    'collection(/albums)': 'albums'
    'collection/tracks':   'tracks'

  initialize: ->
    @el = '#content'

  index: ->
    Backbone.history.navigate "collection/albums", trigger: true

  artists: ->
    @swap new App.Views.ArtistIndex(collection: App.collection.artists)
    R.ready => App.collection.artists.fetch start: 0

  albums: ->
    @swap new App.Views.AlbumIndex(collection: App.collection.albums)
    R.ready => App.collection.albums.fetch start: 0

  tracks: ->
    @swap new App.Views.TrackIndex(collection: App.collection.tracks)
    R.ready => App.collection.tracks.fetch start: 0

