var React = require('react/addons')

var lib = require('../../lib')
var audio = React.DOM.audio

module.exports = React.createClass({
  displayName: 'Queue',

  componentDidMount() {
    var el = this.refs.audio.getDOMNode()
    this.props.ctx.setEl(el)

    el.addEventListener('ended', this.props.onEnded)
    el.addEventListener('error', this.props.onError)
    el.addEventListener('timeupdate', this.handleTimeUpdate)
  },

  componentDidUnmount() {
    var el = this.refs.audio.getDOMNode()

    el.removeEventListener('ended', this.props.onEnded)
    el.removeEventListener('error', this.props.onError)
    el.removeEventListener('timeupdate', this.handleTimeUpdate)
  },

  componentDidUpdate: function(props, state) {
    // this.refs.audio.getDOMNode().load()

    if (props.isPlaying ^ this.props.isPlaying) {
      this.toggle(this.props.isPlaying)
    }
  },

  render() {
    return audio({
      src: mp3url(this.props.track),
      ref: 'audio',
      autoPlay: true,
    })
  },

  handleTimeUpdate(e) {
    this.props.updateScrubTime(this.refs.audio.getDOMNode().currentTime)
  },

  toggle(shouldPlay) {
    shouldPlay ? this.play() : this.pause()
  },

  play() {
    lib.debug('playing', id(this.props.track))

    this.refs.audio.getDOMNode().play()
  },

  pause() {
    lib.debug('pausing', id(this.props.track))

    this.refs.audio.getDOMNode().pause()
  }
})

function id(track) {
  return track && track.id || undefined
}

function mp3url(track) {
  return track && track.stream_url + '?client_id=6da9f906b6827ba161b90585f4dd3726'
}

