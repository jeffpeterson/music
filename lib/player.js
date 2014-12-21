var AudioContext = window.AudioContext || window.webkitAudioContext
var ctx = new AudioContext()
var el = document.createElement('audio')
var source = ctx.createMediaElementSource(el)
var analyser = ctx.createAnalyser()
var gain = ctx.createGain()

el.loop = true

source.connect(analyser)
analyser.connect(gain)
gain.connect(ctx.destination)

gain.gain.value = 1

module.exports = {
  play: function play(track) {
    el.src = mp3Url(track)
    el.play()
  },

  ctx: ctx,
  analyser: analyser
}

function mp3Url(track) {
  return track.stream_url + '?client_id=6da9f906b6827ba161b90585f4dd3726'
}

