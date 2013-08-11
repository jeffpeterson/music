class App.Routers.Collection extends BetterRouter
  routes:
    '':                          'index'
    'collection(/albums)':       'albums'
    'collection/artists':        'artists'
    'collection/tracks':         'tracks'
    'collection/playlists':      'playlists'
    'collection/heavy-rotation': 'heavy_rotation'

  initialize: ->
    @el = '#content'
    @listenTo App, 'search', (query) ->
      return unless @collection
      @collection.filter (item) ->
        item.get('query').match item.clean(query)

    @listenTo App, 'infinite-scroll', -> @collection?.fetch()

    super(arguments...)

  index: ->
    App.go 'collection/albums'

  artists: ->
    @collection = App.collection.artists.fork()

    App.collection.artists.lazy_fetch()
    @swap new App.Views.ArtistIndex(collection: @collection)

  albums: ->
    @collection = App.collection.albums.fork()

    App.collection.albums.lazy_fetch()
    @swap new App.Views.AlbumIndex(collection: @collection)

  playlists: ->
    @collection = App.collection.playlists.fork()

    App.collection.playlists.lazy_fetch()
    @swap new App.Views.PlaylistIndex(collection: @collection)

  tracks: ->
    @collection = App.collection.tracks.fork()

    App.collection.tracks.lazy_fetch()
    @swap new App.Views.TrackIndex(collection: @collection)

  heavy_rotation: ->
    @collection = App.collection.heavy_rotation

    App.collection.heavy_rotation.lazy_fetch()
    @swap new App.Views.AlbumIndex(collection: @collection)

