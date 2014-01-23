class App.Models.Item extends Backbone.Model
  idAttribute: 'key'
  clean: (string = '') ->
    string.toString().toLowerCase().replace(/[^a-z0-9]+/ig, '')


  initialize: ->
    @compute 'rtfLink', ->
      "{\\field{\\*\\fldinst HYPERLINK \"#{ @get('url') }\"}{\\fldrslt #{ @get('full') }}}"

    @compute 'htmlLink', ->
      "<a href='#{ @get('url') }'>#{ @get('full') }</a>"


  fetchByUrl: (options = {}) ->
    @fetch _.defaults options,
      url: @get('url')
      method: 'getObjectFromUrl'

  addToMobile: ->
    isSynced = @get('isInCollection')
    @set isInCollection: true

    App.request 'addToCollection',
      keys: @id
      error: =>
        @set isInCollection: isInCollection


  addToCollection: ->
    isInCollection = @get('isInCollection')
    @set isInCollection: true

    App.request 'addToCollection',
      keys: @id
      error: =>
        @set isInCollection: isInCollection

  removeFromCollection: ->
    isInCollection = @get('isInCollection')
    @set isInCollection: false

    App.request 'removeFromCollection',
      keys: @id
      error: =>
        @set isInCollection: isInCollection

  storeKey: ->
    @constructor.name + ':' + @id

  store: ->
    return unless @storeKey

    store_key = @storeKey?() or @storeKey
    App.store.set store_key, this

  load: ->
    return unless @store_key

    store_key = @storeKey?() or @store_key

    @set App.store.get(store_key, {})
    this

  store_key:         @::storeKey
  add_to_collection: @::addToCollection
  fetch_by_url:      @::fetchByUrl

