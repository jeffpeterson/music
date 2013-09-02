#= require ./base

class App.Adapters.Rdio extends App.Adapters.Base
  loaded: ->
    super()

    App.trigger 'rdio:loaded'
    R.ready =>
      if R.authenticated()
        @is_authenticated = true
        @trigger 'change'
      App.trigger 'rdio:ready'

  initialize:  (options = {}) ->
    super(arguments...)

    @translate 'album',
      name:         'name'
      streamable:   'canStream'
      release_date: 'releaseDate'

  authenticate: (options = {}) ->
    if R.authenticated()
      @is_authenticated = true
      @triggger 'change'
      return
    else
      R.authenticate()

  # e.g. adapter.get('albums', count: 10, start: 20)
  get: (type, options = {}) ->
    this

App.adapters.rdio = new App.Adapters.Rdio
