#= require models/playlist

class App.Models.Queue extends App.Models.Playlist
  defaults:
    current_key:   null
    current_track: null

  initialize: (models) ->
    super()
    @load()
    # @tracks.each (track) ->
    #   track.fetch_by_url()

    @compute 'current_track', ->
      @tracks.get @get('current_key')

    App.on 'rdio:ready', => @rdio_ready()

    @on 'change', @store

    @listenTo @tracks, 'reset', -> @set('current_key', null)
    @listenTo @tracks, 'reset add remove', @store
    @listenTo App.player, "change:position", (player, position) ->
      @next() if (1 - position) * @get('current_track').get('duration') < 2

  rdio_ready: ->
    console.log App.player.get('state'), @get('current_track')
    if App.player.get('state') is "playing" and @get('current_track')
      @play @get('current_track'), App.player.get('position')

  play: (key, position = 0) ->
    unless R.player?
      R.ready => @play(key, position)
      return

    if not key and R.player.playingTrack()
      return R.player.play()

    key or= @get('current_key')
    key = key.id if key.id?

    @set current_key: key
    R.player.play source: key, initialPosition: position * @get('current_track').get('duration')

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

  current_index: (offset = 0) ->
    @tracks.indexOf(@get 'current_track') + offset

  relative: (offset) ->
    index  = @current_index(offset)
    index %= @tracks.length
    index += @tracks.length if index < 0
    index

  store: ->
    App.store.set state: this, queue: @tracks

  load: ->
    @tracks.reset App.store.get('queue')
    @set App.store.get('state')
