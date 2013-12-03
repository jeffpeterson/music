class App.Models.Player extends Backbone.Model
  defaults:
    volume:   1
    position: 0
    shuffle:  false
    repeat:   false
    state:    "stopped"

  initialize: ->
    super()
    @load()

    @listenTo this, "change:position", (player, position) ->
      if App.queue.get('current_track').get('duration') - position < 2
        if @get('repeat')
          @set_position(0)
        else
          App.queue.next()

    @on 'change', @store

    App.on 'rdio:ready', => @rdio_ready()

  rdio_ready: ->
    R.player.on "change:position", => @set position: R.player.position()
    R.player.on "change:volume",   => @set volume:   R.player.volume()
    R.player.on "change:playState", (rdio_play_state) =>
      state = switch rdio_play_state
        when R.player.PLAYSTATE_PAUSED    then 'paused'
        when R.player.PLAYSTATE_PLAYING   then 'playing'
        when R.player.PLAYSTATE_STOPPED   then 'stopped'
        when R.player.PLAYSTATE_BUFFERING then 'buffering'
        when R.player.PLAYSTATE_OFFLINE   then 'offline'

      @set {state}

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

  set_position: (seconds) ->
    R.player.position(seconds)
    @set position: seconds

  toggleRepeat: ->
    @set 'repeat', !@get('repeat')
    this

  setFloatPosition: (float) ->
    seconds = Math.floor(float * App.queue.get('current_track').get('duration'))
    R.player.position(seconds)
    @set position: seconds

  store: -> App.store.set 'Player': this
  load:  -> @set App.store.get('Player')
