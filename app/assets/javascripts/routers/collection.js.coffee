class App.Routers.Collection extends BetterRouter
  routes:
    '':                          'index'
    'collection(/:type)':        'index'

  el: '#content'

  initialize: ->
    @listenTo App, 'search', (query) ->
      @forked_collection?.filter (item) ->
        item.get('query').match item.clean(query)

    @listenTo App, 'infinite-scroll', -> @collection?.fetch()

    super(arguments...)

  index: (type) ->
    return App.go 'collection/albums' unless type

    @set_collection App.collection[type.underscore()]

    @swap new App.Views[type.singularize().camelize() + 'Index'](collection: @forked_collection)

  set_collection: (collection) ->
    @collection        = collection.lazy_fetch()
    @forked_collection = collection.fork()

