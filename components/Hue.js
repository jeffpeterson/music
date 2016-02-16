import React from 'react'
import request from 'lib/request'

import Base from './Base'

export default class Hue extends Base {
  render() {
    let {props: {colors, bassLevel}} = this

    if (!colors || ! colors.background) {
      return null;
    }

    let c = isBright(colors.background) ?
      colors.background : isBright(colors[0]) ?
        colors[0] : colors[1]

    send(2, {xy: xy(c)})
    send(3, {xy: xy(colors[0])})
    send(1, {xy: xy(colors[1])})

    return (
      null
    )
  }
}

function send(i, data) {
  return request({
    data: {transitiontime: 3, ...data},
    url: `http://192.168.1.5/api/arsinh1234/lights/${i}/state`,
    method: 'put',
  })
}
window.send = send

function xy(rgb) {
  return xyz(rgb).slice(0, 2)
}

function xyz(rgb) {
  return rgb2xyz(rgb.split(','))
}

function isBright(rgb) {
  return xyz(rgb)[2] > 0.02
}

function rgb2xyz(rgb) {
  rgb = rgb.map(p => p / 255)

  for (let i in rgb) {
    if (rgb[i] > 0.04045) {
      rgb[i] = Math.pow(((rgb[i] + 0.055) / 1.055), 2.4)
    } else {
      rgb[i] /= 12.92
    }

    // rgb[i] *= 100
  }

  let [r,g,b] = rgb

  let X = r * 0.649926 + g * 0.103455 + b * 0.197109
  let Y = r * 0.234327 + g * 0.743075 + b * 0.022598
  let Z = r * 0.0000000 + g * 0.053077 + b * 1.035763

  // from different formula:
  // let X = r * 0.4124 + g * 0.3576 + b * 0.1805
  // let Y = r * 0.2126 + g * 0.7152 + b * 0.0722
  // let Z = r * 0.0193 + g * 0.1192 + b * 0.9505


  return [
    X / (X + Y + Z),
    Y / (X + Y + Z),
    Z
  ]
}
