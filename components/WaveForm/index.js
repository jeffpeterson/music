var React = require('react')
var canvas = React.DOM.canvas
var Chloroform = require('../../vendor/chloroform')

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}


module.exports = React.createClass({
  displayName: 'WaveForm',

  getDefaultProps: function() {
    return {
      fftSize: 2048
    }
  },

  getInitialState: function() {
    return {
      backgroundRgb: '0,0,0',
      lineRgb: '255,255,255',
      opacity: 1
    }
  },

  componentWillReceiveProps: function(props) {
    if (props.currentTrack !== this.props.currentTrack) {
      this.changeColorsToMatchTrack(props.currentTrack)
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
    var that = this

    ctx.lineWidth = 5

    function draw() {
      var x = 0
      var y, v;

      ctx.fillStyle = 'rgba(' + that.state.backgroundRgb + ', 1)'
      ctx.strokeStyle = 'rgba(' + that.state.lineRgb + ', ' + that.state.opacity + ')'

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
  },

  changeColorsToMatchTrack: function(track) {
    Chloroform.analyze(artUrl(track), function(colors) {
      this.setState({
        backgroundRgb: colors.background,
        lineRgb: colors[0]
      })
    }.bind(this))
  }
})

function warp(x) {
  return -(x * 2 - 2) * x
}
