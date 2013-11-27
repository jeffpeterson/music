#= require ./base

class App.Collections.Items extends App.Collections.Base
  method: 'get'

  store_key: -> @constructor.name

  initialize: (models, options) ->
    @load()
    @on 'add reset remove', (collection) => @store()
    @on 'error', ->
      console.log "SYNC ERROR in", @constructor.name, arguments
      @current_request = null
    super(arguments...)

  fetch: (options = {}) ->
    @current_request or= do =>
      App.debug("Fetching #{@constructor.name}.")
      super _.defaults(options, count: 300, sort: 'dateAdded', remove: false)

  parse: (response, options = {}) ->
    App.debug "Parsing #{@constructor.name}."
    @current_request = null
    super(response.result)

  sync: (method, collection, options) ->
    Backbone.sync method, collection, _.defaults options,
      count: 300
      sort: 'dateAdded'
      start: collection.length
