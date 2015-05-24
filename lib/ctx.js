var AudioContext = window.AudioContext || window.webkitAudioContext

module.exports = ctx

function ctx() {
  var _ctx = new AudioContext()

  _ctx.analyser = _ctx.createAnalyser()

  _ctx.setEl = function(el) {
    _ctx.source = _ctx.createMediaElementSource(el)
    _ctx.source.connect(_ctx.analyser)
    _ctx.source.connect(_ctx.destination)
  }

  return _ctx
}
