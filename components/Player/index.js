var React = require('react')

var audio = React.DOM.audio

module.exports = React.createClass({
  displayName: 'Queue',

  componentDidMount() {
    this.props.ctx.setEl(this.refs.audio.getDOMNode())
  },

  render() {
    console.log('playing', id(this.props.track))

    return audio({
      src: mp3url(this.props.track),
      autoPlay: true,
      ref: 'audio',
      onEnded: this.props.onEnded,
      onError: this.props.onError
    })
  }
})

function id(track) {
  return track && track.id || undefined
}

function mp3url(track) {
  return track.stream_url + '?client_id=6da9f906b6827ba161b90585f4dd3726'
}

