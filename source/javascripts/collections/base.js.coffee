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

  # set: (models, options) ->
  #   super _.select(models, @matching, this), options

  filter: ->
    @reset _.select(@parent.models, @matching, this)

  matching: -> true
