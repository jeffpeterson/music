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

  albums: ->
    @swap new App.AlbumIndexView(collection: App.collection.albums)

  tracks: ->
    @swap new App.TrackIndexView(collection: App.collection.tracks)

