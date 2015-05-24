import lib from 'lib'
import {Base} from './Base'
import React from 'react'

export class Player extends Base {
  componentDidMount() {
    var el = React.findDOMNode(this.refs.audio)
    this.props.ctx.setEl(el)

    el.addEventListener('ended', this.props.onEnded)
    el.addEventListener('error', this.props.onError)
    el.addEventListener('timeupdate', this.handleTimeUpdate())
  }

  componentDidUnmount() {
    var el = React.findDOMNode(this.refs.audio)

    el.removeEventListener('ended', this.props.onEnded)
    el.removeEventListener('error', this.props.onError)
    el.removeEventListener('timeupdate', this.handleTimeUpdate)
  }

  componentDidUpdate(props, state) {
    if (props.isPlaying ^ this.props.isPlaying) {
      this.toggle(this.props.isPlaying)
    }
  }

  render() {
    return <audio
      crossOrigin="anonymous"
      src={mp3url(this.props.track)}
      ref="audio"
      autoPlay={true} />
  }

  handleTimeUpdate() {
    return (e) => {
      this.props
      .updateScrubTime(React.findDOMNode(this.refs.audio).currentTime * 1000)
    }
  }

  toggle(shouldPlay) {
    shouldPlay ? this.play() : this.pause()
  }

  scrubTo(ms) {
    React.findDOMNode(this.refs.audio).currentTime = ms / 1000
  }

  play() {
    lib.debug('playing', id(this.props.track))

    React.findDOMNode(this.refs.audio).play()
  }

  pause() {
    lib.debug('pausing', id(this.props.track))

    React.findDOMNode(this.refs.audio).pause()
  }
}

Player.defaultProps = {
  updateScrubTime() {},
}

function id(track) {
  return track && track.id || undefined
}

function mp3url(track) {
  return track && track.stream_url + '?client_id=6da9f906b6827ba161b90585f4dd3726'
}
