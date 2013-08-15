class App.Adapters.SoundCloud extends App.Adapters.Base
  initialize:  (options = {}) ->
    SC.initialize
      client_id:    '6da9f906b6827ba161b90585f4dd3726'

    @translate 'album',
      name:         'name'
      streamable:   'canStream'
      release_date: 'releaseDate'

  authenticate: (options = {}) ->
    SC.connect

  # e.g. adapter.get('albums', count: 10, start: 20)
  get: (type, options = {}) ->
    switch type
      when 'tracks' then SC.get('/me/favorites', options.success)
    this
