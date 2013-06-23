#= require models/playlist

class App.Models.Queue extends App.Models.Playlist
  defaults:
    current_key:   null
    current_track: null
    shuffle:       false
    repeat:        "all"
    play_state:    "stopped"
    position:      0

  initialize: (models) ->
    super()
    @load()

    R.ready => @rdio_ready()

    @on 'change', @store

    @compute 'current_track', ->
      @tracks.get @get('current_key')

    @listenTo @tracks, 'reset', -> @set('current_key', null)
    @listenTo @tracks, 'reset add remove', ->
      @store()

  rdio_ready: ->
    if @get('play_state') is "playing" and @get('current_track')
      @play @get('current_track'), @get('position')

    R.player.on "change:position", =>
      @set position: R.player.position()

      if R.player.playingTrack().get("duration") - @get('position') < 2
        @next()

  play: (key, position = 0) ->
    if not key and R.player.playingTrack()
      R.player.play()
      return

    key or= @get('current_key')
    key = key.id if key.id?

    @set current_key: key, play_state: "playing"
    R.player.play source: key, initialPosition: position

  next: ->
    @play @relative(1)

  prev: (restart = true) ->
    if restart and @get('position') > 3
      R.player.position(0)
      R.player.play()
    else
      @play @relative(-1)

  pause: ->
    @set play_state: 'paused'
    R.player.pause()

  toggle: ->
    if @get('play_state') is 'playing'
      @pause()
    else
      @play()

  relative: (offset) ->
    index = @tracks.indexOf @get('current_track')
    index += offset
    index %= @tracks.length
    index += @tracks.length if index < 0
    @tracks.at(index)

  store: ->
    localStorage.state = JSON.stringify this
    localStorage.queue = JSON.stringify @tracks

  load: ->
    @tracks.reset JSON.parse(localStorage.queue or null)
    @set JSON.parse(localStorage.state or null)
