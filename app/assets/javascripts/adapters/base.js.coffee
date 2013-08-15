class App.Adapters.Base
  is_authenticated: false
  is_loaded:        false

  constructor: (options = {}) ->
    _.extend this, Backbone.Events
    @initialize(arguments...)

  initialize:  (options = {}) -> this
  translate:   (type, mappings = {}) ->
  loaded: ->
    @is_loaded = true

