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
      @collection.filter (item) ->
        item.get('query').match item.clean(query)

    @listenTo App, 'infinite-scroll', -> @collection.fetch()

    super(arguments...)

  index: ->
    Backbone.history.navigate "collection/albums", trigger: true

  artists: ->
    @collection = App.collection.artists.fork()
    @swap new App.Views.ArtistIndex(collection: @collection)
    App.on 'rdio:ready', => App.collection.artists.init_fetch()

  albums: ->
    @collection = App.collection.albums.fork()

    @swap new App.Views.AlbumIndex(collection: @collection)
    App.on 'rdio:ready', => App.collection.albums.init_fetch()

  playlists: ->
    @collection = App.collection.playlists.fork()

    @swap new App.Views.PlaylistIndex(collection: @collection)
    App.on 'rdio:ready', => App.collection.playlists.init_fetch()

  tracks: ->
    @collection = App.collection.tracks.fork()
    @swap new App.Views.TrackIndex(collection: @collection)
    App.on 'rdio:ready', => App.collection.tracks.init_fetch()

  heavy_rotation: ->
    @swap new App.Views.AlbumIndex(collection: App.collection.heavy_rotation)
    App.on 'rdio:ready',=> App.collection.heavy_rotation.init_fetch()

