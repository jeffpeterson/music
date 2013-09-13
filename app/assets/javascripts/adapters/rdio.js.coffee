#= require ./base

class App.Adapters.Rdio extends App.Adapters.Base
  loaded: ->
    super()

    App.trigger 'rdio:loaded'
    R.ready =>
      @_set 'isAuthenticated', true if R.authenticated()
      App.trigger 'rdio:ready'

  initialize:  (options = {}) ->
    super(arguments...)

    @translate 'album',
      name:         'name'
      streamable:   'canStream'
      release_date: 'releaseDate'

  authenticate: (options = {}) ->
    if R.authenticated()
      @_set 'isAuthenticated', true
    else
      R.authenticate()

  # e.g. adapter.get('albums', count: 10, start: 20)
  get: (type, options = {}) ->
    this

App.adapters.rdio = new App.Adapters.Rdio
