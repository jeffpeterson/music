class App.Collections.Base extends Backbone.Collection
  initialize: (models, options = {}) ->

    super(arguments...)

  lazy_fetch: (options = {}) ->
    if @length is 0
      _.defaults options, reset: true
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
    child = @clone(parent: this, store_key: null)

    @listenTo child, 'add', (models) ->
      @add(models, silent: true)
    child.listenTo this, 'add reset set', (args...) ->
      @set args...

    child

  load: ->
    return unless @store_key

    App.debug("Loading #{@store_key?() or @store_key}.")
    @reset App.get_local(@store_key?() or @store_key, [])
    this

  store: ->
    return unless @store_key

    App.debug("Storing #{@store_key?() or @store_key}.")
    App.set_local(@store_key?() or @store_key, @first(100))
    this
