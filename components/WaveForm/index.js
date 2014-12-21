var React = require('react')
var canvas = React.DOM.canvas

module.exports = React.createClass({
  displayName: 'WaveForm',

  getDefaultProps: function() {
    return {
      fftSize: 2048
    }
  },

  getInitialState: function() {
    return {
    }
  },

  componentDidMount: function() {
    var analyser = this.props.player.analyser
    var canvas = this.getDOMNode()
    canvas.width = canvas.clientWidth * window.devicePixelRatio
    canvas.height = canvas.clientHeight * window.devicePixelRatio
    var width = canvas.width
    var height = canvas.height
    var ctx = canvas.getContext('2d')


    analyser.fftSize = this.props.fftSize
    analyser.smoothingTimeConstant = 1

    var bufferLength = analyser.frequencyBinCount
    var data = new Float32Array(bufferLength)
    var step = width / bufferLength

    ctx.fillStyle = 'black'
    ctx.lineWidth = 5
    ctx.strokeStyle = '#333'

    function draw() {
      var x = 0
      var y, v;

      analyser.getFloatTimeDomainData(data)

      ctx.fillRect(0, 0, width, height)

      ctx.beginPath()

      for(var i = 0; i < bufferLength; i++, x += step) {
        v = data[i] * 0.5 + 0.5
        y = v * height

        if(i === 0) {
          ctx.moveTo(x, y);
        } else {
          ctx.lineTo(x, y);
        }
      }

      ctx.stroke()

      requestAnimationFrame(draw)
    }

    requestAnimationFrame(draw)
  },

  render: function() {
    return canvas({className: 'WaveForm'})
  }
})
