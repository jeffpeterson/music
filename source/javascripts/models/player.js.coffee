class App.Player extends Backbone.Model
  initialize: ->
    console.log "player init"
    R.ready =>
      R.player.on "change:position", => @trigger('change:position')
      R.player.on "change:playState", => @trigger('change change:playState')
      R.player.on "change:volume", => @trigger("change change:volume")
      this
  play: ->
    App.queue.play()

  pause: ->
    App.queue.pause()

  prev: ->
    App.queue.prev()

  next: ->
    App.queue.next()

  toggle: ->
      App.queue.toggle()

  volume: (percent) ->
    if percent
      R.player.volume(percent / 100)
    Math.round(R.player.volume() * 100)

  position: (percent) ->
    if percent
      R.player.position percent / 100 * R.player.playingTrack().get("duration")
      return
    if R.player.playingTrack()
      R.player.position() / R.player.playingTrack().get("duration") * 100
    else
      0
