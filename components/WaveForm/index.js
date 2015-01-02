var React = require('react/addons')
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

    var bufferLength = analyser.fftSize
    var buffer = new Uint8Array(bufferLength)
    var step = width / bufferLength
    var that = this

    ctx.lineWidth = 4
    ctx.fillStyle = 'rgba(0,0,0, 0)'

    function draw() {
      var colors = that.props.colors
      var x, y

      ctx.strokeStyle = rgb(colors[0])

      analyser.getByteTimeDomainData(buffer)

      ctx.globalCompositeOperation = 'destination-in'
      ctx.fillRect(0, 0, width, height)

      ctx.beginPath()

      for (var i = 0; i < bufferLength; i++) {
        x = i * step
        y = 0.00390625 * buffer[i] * height

        if(i === 0) {
          ctx.moveTo(x, y);
        } else {
          ctx.lineTo(x, y);
        }
      }

      ctx.globalCompositeOperation = 'source-over'
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
