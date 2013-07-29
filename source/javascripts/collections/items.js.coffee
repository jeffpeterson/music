#= require ./base

class App.Collections.Items extends App.Collections.Base
  method: 'get'

  store_key: -> @constructor.name

  initialize: (models, options) ->
    @load()
    @on 'reset', (collection) => @store()
    super(arguments...)

  init_fetch: (options = {}) ->
    @fetch _.defaults(options, start: 0, reset: true)

  fetch: (options = {}) ->
    @current_request or= do =>
      App.debug("Fetching #{@constructor.name}.")
      super _.defaults(options, count: 100, sort: 'dateAdded', remove: false)

  parse: (response, options = {}) ->
    App.debug "Parsing #{@constructor.name}."
    @current_request = null
    super(response.result)

  sync: (method, collection, options) ->
    Backbone.sync method, collection, _.defaults options,
      count: 100
      sort: 'dateAdded'
      start: collection.length
