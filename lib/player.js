var AudioContext = window.AudioContext || window.webkitAudioContext
var ctx = new AudioContext()
var el = document.createElement('audio')
var source = ctx.createMediaElementSource(el)
var analyser = ctx.createAnalyser()
var gain = ctx.createGain()

source.connect(analyser)
analyser.connect(gain)
gain.connect(ctx.destination)

gain.gain.value = 0.1

module.exports = {
  play: function play(url) {
    el.src = url
    el.play()
  },

  ctx: ctx,
  analyser: analyser
}


