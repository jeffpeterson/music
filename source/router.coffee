class App.Router extends BetterRouter
  routes:
    'settings':              'settings'
    'reset-colors':          'resetColors'
    'top-charts':            'topCharts'
    'notifications':         'notifications'
    'collection':            'collection'
    'heavy-rotation':        'heavyRotation'
    ':artist/:album/:track': 'track'
    ':artist/:album':        'album'
    ':artist':               'artist'
    '':                      'collection'

  initialize: ->
    @el = '#content'
    super(arguments...)


  settings: ->
    alert 'settings'


  resetColors: ->
    App.store.set 'colors', {}
    Backbone.history.navigate 'collection'
    window.location.reload()

  topCharts: ->
    @setCollection App.catalog.top_charts
    @swap new Component.TopCharts(collection: @collection)

  notifications: ->

  heavyRotation: ->
    @collection 'heavy_rotation'

  collection: (type = 'albums') ->
    @setCollection App.collection[type]
    @swap new Component[L.camelize(type)](collection: @collection)

  album: (artistName, albumName) ->
    @collection()

    album = App.collection.albums.findWhere route: "#{artistName}/#{albumName}"

    unless album
      album = new App.Models.Album
        url: "/artist/#{artistName}/album/#{albumName}/"
      album.fetchByUrl()

    view = new Component.Album.Modal model: album
    $("body").append view.render().el

  bindEvents: ->
    @listenTo App, 'search', (query) ->
      @collection.trigger('filter', @collection.model::clean(query))

    @listenTo App, 'infinite-scroll', -> @collection?.fetch()

  setCollection: (collection) ->
    @collection = collection.lazy_fetch()
    @bindEvents()
