class App.Models.Item extends Backbone.Model
  method: 'get'
  idAttribute: 'key'
  clean: (string = '') ->
    string.toString().toLowerCase().replace(/[^a-z0-9]+/ig, '')

  fetch_by_url: (options = {}) ->
    @fetch _.defaults options,
      url: @get('url')
      method: 'getObjectFromUrl'

  parse: (response, options = {}) ->
    @current_request = null
    if response.result
      super(response.result)
    else
      super(response)

  add_to_collection: ->
    @set isInCollection: true
    App.request 'addToCollection',
      keys: @get('key')
      error: =>
        @set @previousAttributes

  store_key: ->
    @constructor.name + ':' + @id

  store: ->
    return unless @store_key

    store_key = @store_key?() or @store_key
    App.store.set store_key, this

  load: ->
    return unless @store_key

    store_key = @store_key?() or @store_key

    @set App.store.get(store_key, {})
    this
