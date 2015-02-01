import {css} from '../lib'
import React from 'react/addons'

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
    var bassDelta = 0
    var analyser = this.props.ctx.analyser
    var canvas = this.getDOMNode()
    canvas.width = canvas.clientWidth * window.devicePixelRatio
    canvas.height = canvas.clientHeight * window.devicePixelRatio
    var width = canvas.width
    var height = canvas.height
    var ctx = canvas.getContext('2d')

    analyser.fftSize = this.props.fftSize
    analyser.smoothingTimeConstant = 0.5

    var buffer = new Uint8Array(analyser.fftSize)
    var freqBuffer = new Float32Array(analyser.frequencyBinCount)
    var that = this

    ctx.lineWidth = 4
    ctx.fillStyle = 'rgba(0,0,0, 0)'

    function draw() {
      if (!that.isMounted()) {
        return
      }

      var bassLevel = Math.max(0, calcBassLevel(freqBuffer))
      var colors = that.props.colors
      var x, y

      ctx.strokeStyle = rgba(colors[0], bassLevel * 2)

      analyser.getByteTimeDomainData(buffer)
      analyser.getFloatFrequencyData(freqBuffer)

      ctx.globalCompositeOperation = 'destination-in'
      ctx.fillRect(0, 0, width, height)

      ctx.beginPath()

      for (var i = 0, l = buffer.length; i < l; i++) {
        x = i * width / l
        // y = -buffer[i]
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
    return <canvas className={'WaveForm'} />
  },

  opacity: function() {
    return this.props.isDimmed ? 0.2 : 1
  }
})

css('.WaveForm', {
  left: 0,
  top: 0,
  width: '100%',
  height: '100%',
  zIndex: -1,
  position: 'absolute',
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

function incAvg(avg, x, i) {
  return (avg * i + x) / (i + 1)
}

function avg(nums) {
  return nums.reduce(incAvg)
}

var pBassLevel = 0

function calcBassLevel(f) {
  return 1 - avg([f[0], f[1], f[2], f[3]]) / avg([f[50], f[100], f[300], f[600]])
}

