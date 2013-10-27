class App.Routers.Catalog extends BetterRouter
  routes:
    'catalog(/:type)':        'index'

  el: '#content'

  initialize: ->
    @listenTo Backbone.history, 'route', @stopListening

    super(arguments...)

  index: (type) ->
    return App.go 'catalog/top-charts' unless type

    @set_collection App.catalog[type.underscore()]

    @bind_events()
    @swap new App.Views[type.singularize().camelize() + 'Index'](collection: @collection)

  bind_events: ->
    @listenTo App, 'search', (query) ->
      @collection.trigger('filter', @collection.model::clean(query))

    @listenTo App, 'infinite-scroll', -> @collection?.fetch()

  set_collection: (collection) ->
    @collection = collection.lazy_fetch()
