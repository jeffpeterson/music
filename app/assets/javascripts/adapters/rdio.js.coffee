#= require ./base

class App.Adapters.Rdio extends App.Adapters.Base
  initialize:  (options = {}) ->
    @translate 'album',
      name:         'name'
      streamable:   'canStream'
      release_date: 'releaseDate'

  authenticate: (options = {}) ->
    if R.authenticated()
      return
    else
      R.authenticate()

  # e.g. adapter.get('albums', count: 10, start: 20)
  get: (type, options = {}) ->
    this
