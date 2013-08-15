class App.Adapters.SoundCloud extends App.Adapters.Base
  initialize: (options) ->
    @translate 'album',
      name:         'name'
      streamable:   'canStream'
      release_date: 'releaseDate'

  loaded: ->
    super()

    SC.initialize
      client_id:    '6da9f906b6827ba161b90585f4dd3726'
      redirect_uri: 'http://music.dev/callback.html'

    if token = App.get_local('sound_cloud_token')
      @is_authenticated = true
      @trigger 'change'
      SC.accessToken token

  authenticate: (options = {}) ->
    SC.connect =>
      @is_authenticated = true
      App.set_local sound_cloud_token: SC.accessToken()

      @trigger 'change'
      console.log 'SoundCloud authenticated.'

  # e.g. adapter.get('albums', count: 10, start: 20)
  get: (type, options = {}) ->
    switch type
      when 'tracks' then SC.get('/me/favorites', options.success)
    this

App.adapters.sound_cloud = new App.Adapters.SoundCloud

