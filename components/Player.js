import lib from 'lib'
import Base from './Base'
import React from 'react'
import {findDOMNode} from 'react-dom'

export default class Player extends Base {
  componentDidMount() {
    var el = findDOMNode(this.refs.audio)
    this.props.ctx.setEl(el)
    this.scrubTo(this.props.playState.scrubTime)
  }

  componentDidUpdate(pprops, pstate) {
    if (pprops.playState.isPlaying ^ this.props.playState.isPlaying) {
      this.toggle(this.props.playState.isPlaying)
    }

    if (Math.abs(pprops.playState.scrubTime - this.props.playState.scrubTime) > 1000) {
      this.scrubTo(this.props.playState.scrubTime)
    }
  }

  render() {
    const {
      props: {track, playState}
    } = this

    return <audio
      ref="audio"
      crossOrigin="anonymous"
      src={mp3url(track)}
      onEnded={this.ended}
      onError={this.error}
      onTimeUpdate={this.timeUpdate}
      autoPlay={playState.isPlaying} />
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

  timeUpdate = e => {
    const t = findDOMNode(this.refs.audio).currentTime * 1000
    this.props.dispatch('PLAY_TIME_UPDATED', t)
  }

  ended = e => {
    this.props.dispatch('PLAY_ENDED', null)
  }

  error = e => {
    this.props.dispatch('PLAY_ERRORED', null)
  }
}

Player.defaultProps = {
  scrubTime: 0,
}

function id(track) {
  return track && track.id || undefined
}

function mp3url(track) {
  return track && track.stream_url + '?client_id=' + lib.CLIENT_ID
}
