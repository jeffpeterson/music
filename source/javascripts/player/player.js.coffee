class App.Player extends Backbone.Model
  initialize: ->
    console.log "player init"
    R.ready =>
      R.player.on "change:position", => @trigger('change:position')
      R.player.on "change:playState", => @trigger('change change:playState')
      this
  play: ->
    if R.player.playingTrack()
      R.player.play()
    else
      App.queue.play()
  pause: ->
    R.player.pause()
  prev: ->
    App.queue.prev()
  next: ->
    App.queue.next()
  toggle: ->
    R.player.togglePause()
  position: (percent) ->
    if percent
      R.player.position percent / 100 * R.player.playingTrack().get("duration")
      return
    if R.player.playingTrack()
      R.player.position() / R.player.playingTrack().get("duration") * 100
    else
      0
