import {css} from 'lib'
import Base from './Base'
import React from 'react'
import {findDOMNode} from 'react-dom'
import {rgb, rgba, mix} from 'lib/color'

export default class WaveForm extends Base {
  componentDidMount() {
    var bassDelta = 0
    var analyser = this.props.ctx.analyser
    var canvas = findDOMNode(this)
    canvas.width = canvas.clientWidth * window.devicePixelRatio
    canvas.height = canvas.clientHeight * window.devicePixelRatio

    analyser.fftSize = this.props.fftSize

    var timeBuffer = new Uint8Array(analyser.fftSize)

    var width = canvas.width
    var height = canvas.height
    var h = 0.00390625 * height
    var l = timeBuffer.length
    var w = width / l
    var ctx = canvas.getContext('2d')

    // var freqBuffer = new Uint8Array(analyser.frequencyBinCount)
    var that = this

    ctx.lineWidth = 4

    requestAnimationFrame(draw)

    function draw() {
      requestAnimationFrame(draw)

      if (document.hidden) return

      let {colors, isPlaying} = that.props


      ctx.fillStyle = rgba(colors.background, 0.1)
      ctx.fillRect(0, 0, width, height)

      if (!isPlaying) return

      // analyser.getByteFrequencyData(freqBuffer)

      // ctx.shadowBlur = 0
      // ctx.fillStyle = rgba(colors[1], 0.9)

      // for (let i = 0, l = freqBuffer.length, w = width / l; i < l; i++) {
      //   let f = 0.00390625 * freqBuffer[i] / 2

      //   ctx.fillRect(
      //     i * w,
      //     (1 - f) * height,
      //     (i + 1) * w,
      //     f * height,
      //   )
      // }

      analyser.getByteTimeDomainData(timeBuffer)
      ctx.strokeStyle = rgba(colors[0], 1)
      ctx.shadowColor = rgba(colors[1], 0.5);
      ctx.shadowBlur = 30

      ctx.beginPath()

      for (let i = 0; i < l; i++) {
        let scale = i / l
        ctx.lineTo(i * w, h * timeBuffer[i])
      }

      stroke(ctx)
    }
  }

  render() {
    let {
      props: {isDimmed}
    } = this

    let style = {
      opacity: isDimmed ? 0.2 : 0.9
    }

    return <canvas style={style} className="WaveForm" />
  }
}

WaveForm.defaultProps = {
  fftSize: 2048,
  isDimmed: false,
  colors: {0: '255,255,255', 1: '255,255,255'},
}

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

function incAvg(avg, x, i) {
  return (avg * i + x) / (i + 1)
}

function avg(nums) {
  return nums.reduce(incAvg)
}

function stroke(ctx) {
  return ctx.stroke()
}
