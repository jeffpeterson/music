#= require track/track

class App.Queue extends App.Playlist
  model: App.Track

  initialize: ->
    @state = JSON.parse(localStorage.state || "null")
    @state ||=
      current_key: null
      shuffle: false
      repeat: "all"

    @on 'reset', (collection) =>
      @state.current_key = null

    @on 'add', ->
      @save()

    R.ready =>
      R.player.on "change:playingTrack", => @trigger("change change:playingTrack")
      R.player.on "change:position", =>
        if R.player.playingTrack().get("duration") - R.player.position() < 2
          @next()

  play: (track = @current_track()) ->
    @state.current_key = track.get('key')
    @save()

    R.player.play source: @state.current_key

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

  current_track: (attr) ->
    track = @get(@state.current_key)
    if attr
      track.get(attr)
    else
      track

