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
    var width = canvas.width
    var height = canvas.height
    var ctx = canvas.getContext('2d')

    analyser.fftSize = this.props.fftSize
    analyser.smoothingTimeConstant = 0.5

    var buffer = new Uint8Array(analyser.fftSize)
    var that = this

    ctx.lineWidth = 4

    requestAnimationFrame(draw)

    function draw() {
      requestAnimationFrame(draw)
      analyser.getByteTimeDomainData(buffer)
      let {colors} = that.props

      ctx.strokeStyle = rgb(colors[0])
      ctx.clearRect(0, 0, width, height)

      ctx.beginPath()

      for (let i = 0, l = buffer.length; i < l; i++) {
        ctx.lineTo(i * width / l, 0.00390625 * buffer[i] * height)
      }

      stroke(ctx)
    }
  }

  render() {
    let {
      props: {isDimmed}
    } = this

    let style = {
      opacity: isDimmed ? 0.2 : 1
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
