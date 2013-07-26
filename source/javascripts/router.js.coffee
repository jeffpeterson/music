class App.Router extends BetterRouter
  routes:
    '': 'index'
    'collection/artists':  'artists'
    'collection(/albums)': 'albums'
    'collection/tracks':   'tracks'
    'collection/heavy-rotation': 'heavy_rotation'

  initialize: ->
    @el = '#content'
    @listenTo App, 'search', (query) ->
      @collection.matching = (item) ->
        item.get('query').match item.clean(query)

      @collection.filter()

    @listenTo App, 'infinite-scroll', -> @collection.fetch()

    super(arguments...)

  index: ->
    Backbone.history.navigate "collection/albums", trigger: true

  artists: ->
    @collection = App.collection.artists
    @swap new App.Views.ArtistIndex(collection: @collection)
    App.on 'rdio:ready', => App.collection.artists.init_fetch()

  albums: ->
    @collection = new App.Collections.Albums App.collection.albums.models,
      parent: App.collection.albums

    @swap new App.Views.AlbumIndex(collection: @collection)
    App.on 'rdio:ready', => App.collection.albums.init_fetch()

  tracks: ->
    @collection = App.collection.tracks
    @swap new App.Views.TrackIndex(collection: @collection)
    App.on 'rdio:ready', => App.collection.tracks.init_fetch()

  heavy_rotation: ->
    @swap new App.Views.AlbumIndex(collection: App.collection.heavy_rotation)
    App.on 'rdio:ready',=> App.collection.heavy_rotation.init_fetch()

