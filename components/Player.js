import lib from 'lib'
import Base from './Base'
import React from 'react'
import {findDOMNode} from 'react-dom'

export default class Player extends Base {
  componentDidMount() {
    var el = findDOMNode(this.refs.audio)
    this.props.ctx.setEl(el)
    this.scrubTo(this.props.scrubTime)

    el.addEventListener('ended', this.props.onEnded)
    el.addEventListener('error', this.props.onError)
    el.addEventListener('timeupdate', this.handleTimeUpdate.bind(this))
  }

  componentWillUnmount() {
    var el = findDOMNode(this.refs.audio)

    el.removeEventListener('ended', this.props.onEnded)
    el.removeEventListener('error', this.props.onError)
    el.removeEventListener('timeupdate', this.handleTimeUpdate)
  }

  componentDidUpdate(pprops, pstate) {
    if (pprops.isPlaying ^ this.props.isPlaying) {
      this.toggle(this.props.isPlaying)
    }

    if (Math.abs(pprops.scrubTime - this.props.scrubTime) > 1000) {
      this.scrubTo(this.props.scrubTime)
    }
  }

  render() {
    let {
      props: {track, isPlaying}
    } = this

    return <audio
      crossOrigin="anonymous"
      src={mp3url(track)}
      ref="audio"
      autoPlay={isPlaying} />
  }


  handleTimeUpdate(e) {
    this.props
    .updateScrubTime(findDOMNode(this.refs.audio).currentTime * 1000)
  }

  toggle(shouldPlay) {
    shouldPlay ? this.play() : this.pause()
  }

  scrubTo(ms) {
    findDOMNode(this.refs.audio).currentTime = ms / 1000
  }

  play() {
    lib.debug('playing', id(this.props.track))

    findDOMNode(this.refs.audio).play()
  }

  pause() {
    lib.debug('pausing', id(this.props.track))

    findDOMNode(this.refs.audio).pause()
  }
}

Player.defaultProps = {
  updateScrubTime() {},
  scrubTime: 0,
}

function id(track) {
  return track && track.id || undefined
}

function mp3url(track) {
  return track && track.stream_url + '?client_id=' + lib.CLIENT_ID
}
