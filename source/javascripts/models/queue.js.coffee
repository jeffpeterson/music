#= require models/playlist

class App.Models.Queue extends App.Models.Playlist
  defaults:
    current_track: null
    index:         0
    key:           null

  initialize: (models) ->
    super()
    @load()

    App.on 'rdio:ready', => @rdio_ready()

    @on 'all', @store

    @listenTo @tracks, 'reset', -> @set('current_track', null)

  rdio_ready: ->
    R.player.on 'change:sourcePosition', (index) ->
      @set index: index

    R.player.on 'change:playingTrack', (track) =>
      @set current_track: @tracks.get(track)

    R.player.on 'change:playingSource', (playlist) =>
      console.log 'changed source to', source
      playlist = playlist.attributes

      if playlist.type is 'p'
        @clear        silent: true
        @set          _.omit(playlist, 'tracks', 'owner')
        @tracks.reset _.pluck(playlist.tracks, 'attributes')

  play: (track, position = 0) ->
    unless R.player?
      return R.ready => @play(key, position)

    key = track.id? or track

    if not key and R.player.playingTrack()
      return R.player.play()

    key or= @get('current_key')

    @set current_key: key
    R.player.play source: key, initialPosition: position * @get('current_track').get('duration')

  next:  -> R.player.next()
  prev:  -> R.player.previous()
  pause: -> R.player.pause()

  current_index: (offset = 0) ->
    @tracks.indexOf(@get 'current_track') + offset

  relative: (offset) ->
    index  = @current_index(offset)
    index %= @tracks.length
    index += @tracks.length if index < 0
    index

  store: ->
    App.debug 'Storing queue.'
    App.set_local queue: this, queue_tracks: @tracks

  load: ->
    @tracks.reset App.get_local('queue_tracks')
    @set App.get_local('queue')
