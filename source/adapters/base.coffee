class App.Adapters.Base extends Backbone.Model
  defaults:
    isAuthenticated: false
    isLoaded:        false

  initialize: (options = {}) ->
    @translations = {}
    this

  translate: (type, mappings = {}) ->
    @translations[type] = mappings

  loaded: ->
    @_set 'isLoaded', true

  _get: Backbone.Model::get
  _set: Backbone.Model::set
