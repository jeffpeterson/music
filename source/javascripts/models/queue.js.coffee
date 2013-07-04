#= require models/playlist

class App.Models.Queue extends App.Models.Playlist
  defaults:
    current_key:   null
    current_track: null

  initialize: (models) ->
    super()
    @load()

    R.ready => @rdio_ready()

    @on 'change', @store

    @compute 'current_track', ->
      @tracks.get @get('current_key')

    @listenTo @tracks, 'reset', -> @set('current_key', null)
    @listenTo @tracks, 'reset add remove', @store
    @listenTo App.player, "change:position", (player, position) ->
      @next() if position > 0.99

  rdio_ready: ->
    if App.player.get('state') is "playing" and @get('current_track')
      @play @get('current_track'), @get('position')

  play: (key, position = 0) ->
    return unless R.player?

    if not key and R.player.playingTrack()
      R.player.play()
      return

    key or= @get('current_key')
    key = key.id if key.id?

    @set current_key: key
    R.player.play source: key, initialPosition: position

  next: ->
    @play @tracks.at(@relative(1))

  prev: (restart = true) ->
    if restart and @get('position') > 3
      R.player.position(0)
      R.player.play()
    else
      @play @tracks.at(@relative(-1))

  pause: ->
    R.player?.pause()

  relative: (offset) ->
    index = @tracks.indexOf @get('current_track')
    index += offset
    index %= @tracks.length
    index += @tracks.length if index < 0
    index

  store: ->
    localStorage.state = JSON.stringify this
    App.set_local state: this, queue: @tracks

  load: ->
    @tracks.reset App.get_local('queue')
    @set App.get_local('state')
