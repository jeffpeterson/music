class App.Models.Player extends Backbone.Model
  defaults:
    volume:   1
    position: 0
    shuffle:  false
    repeat:   "all"
    state:    "stopped"

  initialize: ->
    super()
    @load()

    @on 'change', @store

    R.ready => @rdio_ready()

  rdio_ready: ->
    R.player.on "change:position", => @set position: R.player.position() / R.player.playingTrack().get('duration')
    R.player.on "change:volume",   => @set volume:   R.player.volume()
    R.player.on "change:playState", (play_state) =>
      @set state: switch play_state
        when R.player.PLAYSTATE_PAUSED    then 'paused'
        when R.player.PLAYSTATE_PLAYING   then 'playing'
        when R.player.PLAYSTATE_STOPPED   then 'stopped'
        when R.player.PLAYSTATE_BUFFERING then 'buffering'
        when R.player.PLAYSTATE_OFFLINE   then 'offline'


  play: ->
    @set state: 'playing'
    App.queue.play()

  pause: ->
    @set state: 'paused'
    App.queue.pause()

  prev: ->
    App.queue.prev()

  next: ->
    App.queue.next()

  toggle: ->
    if @get('state') is 'playing'
      @pause()
    else
      @play()

  set_volume:   (float) ->
    R.player.volume(float)
    @set volume: float

  set_position: (float) ->
    R.player.position(float * R.player.playingTrack().get("duration"))
    @set position: float

  store: -> App.set_local 'Player': this
  load:  -> @set App.get_local('Player')
