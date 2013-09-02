class App.Adapters.Base
  is_authenticated: false
  is_loaded:        false

  constructor: (options = {}) ->
    _.extend this, Backbone.Events
    @initialize(arguments...)

  initialize:  (options = {}) ->
    @translations = {}
    this

  translate:   (type, mappings = {}) ->
    @translations[type] = mappings

  loaded: ->
    @is_loaded = true

