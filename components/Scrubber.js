import React from 'react'
import {css} from 'lib'
import {Base} from './Base'
import {rgb, rgba} from 'lib/color'

export class Scrubber extends Base {
  constructor(props) {
    super(props)
  }

  render() {
    let {colors} = this.props

    return (
      <div
        className="Scrubber"
        onClick={this.handleClick.bind(this)}>

        <div className="Scrubber-progress" style={this.progressStyle()} />
      </div>
    )
  }

  progressStyle() {
    let {colors} = this.props

    return {
      backgroundColor: rgb(colors[2]),
      transform: translate(this.width()),
    }
  }

  width() {
    let {scrubTime, currentTrack} = this.props
    return (scrubTime / currentTrack.duration - 1) * 100 + "%"
  }

  handleClick(e) {
    let {duration} = this.props.currentTrack
    let {left, width} = e.currentTarget.getBoundingClientRect()
    let x = e.clientX - left

    this.props.onScrub(x / width * duration)
  }
}

Scrubber.defaultProps = {
  onScrub() {},
}

function translate(x, y = 0, z = 0) {
  return `translate3D(${x}, ${y}, ${z})`
}

css('.Scrubber', {
  height: 5,
  position: 'absolute',
  top: 0,
  left: 0,
  right: 0,
  overflow: 'hidden',
  cursor: 'pointer',
})

css('.Scrubber-progress', {
  position: 'absolute',
  top: 0,
  left: 0,
  right: 0,
  bottom: 0,
})
