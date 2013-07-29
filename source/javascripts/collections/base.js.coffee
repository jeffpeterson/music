class App.Collections.Base extends Backbone.Collection
  initialize: (models, options = {}) ->
    @parent   = options.parent   if options.parent
    @matching = options.matching if options.matching

    if @parent
      @listenTo this, 'add', (models) ->
        @parent.add(models, silent: true)
      @listenTo @parent, 'add reset set', (args...) ->
        @set args...

    super(arguments...)

  lazy_fetch: (options = {}) ->
    if @length is 0
      _.defaults options, reset: true
      @fetch(options)
    this

  filter: ->
    @reset _.select(@parent.models, @matching, this)

  matching: -> true

  clone: (params = {}) ->
    collection = super()
    for key, value of params
      collection[key] = value
    collection

  fork: (params = {}) ->
    @clone(parent: this, store_key: null)

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
