#= require models/track
#= require ./playlist

class App.Queue extends App.Playlist
  model: App.Track

  initialize: (models) ->
    @load()

    @on 'reset', (collection) =>
      @state.current_key = null
    @on 'add', ->
      @save()
    @on 'remove', ->
      @save()

    R.ready =>
      console.log @state.play_state
      if @state.play_state is "playing" and @current_track()
        @play @current_track(), @state.position

      R.player.on "change:playingTrack", => @trigger("change change:playingTrack")
      R.player.on "change:position", =>
        @state.position = R.player.position()
        @save()

        if R.player.playingTrack().get("duration") - @state.position < 2
          @next()

  play: (track = @current_track(), position = 0) ->
    @add track, at: @relative(1) unless @get(track.id)

    @state.current_key = track.id
    @state.play_state  = "playing"

    R.player.play source: @state.current_key, initialPosition: position
    @save()

  next: ->
    @play @at(@relative(1))

  relative: (offset) ->
    index = @indexOf(@current_track())
    index += offset
    index %= @length
    index += @length if index < 0
    index

  prev: (restart = true) ->
    if restart and R.player.position() > 3
      R.player.position(0)
      R.player.play()
    else
      @play @at(@relative(-1))

  save: ->
    localStorage.queue = JSON.stringify(this)
    localStorage.state = JSON.stringify(@state)

  load: ->
    @state = JSON.parse(localStorage.state or null)

    @state or=
      current_key: null
      shuffle: false
      repeat: "all"
      play_state: "stopped"
      position: 0

  current_track: (attr) ->
    track = @get(@state.current_key)
    if attr
      track.get(attr)
    else
      track

