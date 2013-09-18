class App.Routers.Collection extends BetterRouter
  routes:
    '':                          'index'
    'collection(/:type)':        'index'

  el: '#content'

  initialize: ->
    @listenTo App, 'search', (query) ->
      @collection.trigger('filter', @collection.model::clean(query))

    @listenTo App, 'infinite-scroll', -> @collection?.fetch()

    super(arguments...)

  index: (type) ->
    return App.go 'collection/albums' unless type

    @set_collection App.collection[type.underscore()]

    @swap new App.Views[type.singularize().camelize() + 'Index'](collection: @collection)

  set_collection: (collection) ->
    @collection = collection.lazy_fetch()
