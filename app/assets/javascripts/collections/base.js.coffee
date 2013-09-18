class App.Collections.Base extends Backbone.Collection
  initialize: (models, options = {}) ->

    super(arguments...)

  lazy_fetch: (options = {}) ->
    if @length is 0 or @isStale
      _.defaults options, reset: true, start: 0
      @fetch(options)
    this

  filter: (matching = @matching) ->
    @reset _.select(@parent.models, matching, this)

  matching: -> true

  clone: (params = {}) ->
    collection = super()
    for key, value of params
      collection[key] = value
    collection

  fork: (params = {}) ->
    child = @clone parent: this, store_key: null

    child.listenTo this, 'all', (ev, model, collection, options) ->
      return unless ev is 'add' or ev is 'remove'
      this[ev](model)

    child

  load: ->
    return unless @store_key

    store_key = @store_key?() or @store_key
    keys = App.store.get(store_key, [])

    @isStale = true
    @reset ({key} for key in keys)
    for model in @models
      model.load()

  store: ->
    return unless @store_key
    store_key = @store_key?() or @store_key

    model.store() for model in @models
    App.store.set store_key, @pluck('key')
