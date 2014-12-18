var AudioContext = window.AudioContext || window.webkitAudioContext
var ctx = new AudioContext()
var el = document.createElement('audio')
var source = ctx.createMediaElementSource(el)
var analyser = ctx.createAnalyser()

source.connect(analyser)
analyser.connect(ctx.destination)

module.exports = {
  play: function play(url) {
    el.src = url
    el.play()
  },

  ctx: ctx,
  analyser: analyser
}


