var React = require('react')
var canvas = React.DOM.canvas

module.exports = React.createClass({
  displayName: 'WaveForm',

  getDefaultProps: function() {
    return {
      fftSize: 2048,
      isDimmed: false,
      colors: {0: '255,255,255', 1: '255,255,255'},
    }
  },

  componentDidMount: function() {
    var analyser = this.props.ctx.analyser
    var canvas = this.getDOMNode()
    canvas.width = canvas.clientWidth * window.devicePixelRatio
    canvas.height = canvas.clientHeight * window.devicePixelRatio
    var width = canvas.width
    var height = canvas.height
    var ctx = canvas.getContext('2d')

    analyser.fftSize = this.props.fftSize
    analyser.smoothingTimeConstant = 0

    var bufferLength = analyser.frequencyBinCount
    var data = new Uint8Array(bufferLength)
    var step = width / bufferLength
    var that = this

    ctx.lineWidth = 4
    ctx.shadowBlur = 30
    ctx.shadowOffsetX = 0
    ctx.shadowOffsetY = 0

    function draw() {
      var colors = that.props.colors
      var x = 0
      var y

      ctx.shadowColor = rgb(colors[2])

      var gradient = ctx.strokeStyle = ctx.createLinearGradient(0, 0, width, 0)
      gradient.addColorStop(0, rgb(colors[0]))
      gradient.addColorStop(1, rgb(colors[1]))

      analyser.getByteTimeDomainData(data)

      ctx.clearRect(0, 0, width, height)

      ctx.beginPath()

      for (var i = 0; i < bufferLength; i++, x += step) {
        y = 0.00390625 * data[i] * height

        if(i === 0) {
          ctx.moveTo(x, y);
        } else {
          ctx.lineTo(x, y);
        }
      }

      ctx.globalAlpha = that.opacity()
      ctx.stroke()

      requestAnimationFrame(draw)
    }

    requestAnimationFrame(draw)
  },

  render: function() {
    return canvas({className: 'WaveForm'})
  },

  opacity: function() {
    return this.props.isDimmed ? 0.2 : 1
  }
})

function warp(x) {
  return -(x * 2 - 2) * x
}

function rgba(color, alpha) {
  return `rgba(${color}, ${alpha})`
}

function rgb(color) {
  return `rgb(${color})`
}
