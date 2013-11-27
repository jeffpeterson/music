class App.Routers.Collection extends BetterRouter
  routes:
    '':                   'index'
    'collection(/:type)': 'index'
    'heavy-rotation':     'heavyRotation'

  el: '#content'

  initialize: ->
    @listenTo Backbone.history, 'route', @stopListening

    super(arguments...)

  heavyRotation: ->
    @index('heavy-rotation')

  index: (type = 'albums') ->
    @set_collection App.collection[L.underscore(type)]

    @bind_events()
    @swap new Component[L.camelize(type)](collection: @collection)

  bind_events: ->
    @listenTo App, 'search', (query) ->
      @collection.trigger('filter', @collection.model::clean(query))

    @listenTo App, 'infinite-scroll', -> @collection?.fetch()

  set_collection: (collection) ->
    @collection = collection.lazy_fetch()
