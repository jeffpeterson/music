class App.Models.Item extends Backbone.Model
  idAttribute: 'key'
  clean: (string = '') ->
    string.toString().toLowerCase().replace(/[^a-z0-9]+/ig, '')


  initialize: ->
    @compute 'rtfLink', ->
      "{\\field{\\*\\fldinst HYPERLINK \"#{ @get('url') }\"}{\\fldrslt #{ @get('full') }}}"

    @compute 'htmlLink', ->
      "<a href='#{ @get('url') }'>#{ @get('full') }</a>"


  fetch_by_url: (options = {}) ->
    @fetch _.defaults options,
      url: @get('url')
      method: 'getObjectFromUrl'

  add_to_collection: ->
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
