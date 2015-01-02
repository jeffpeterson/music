var React = require('react/addons')
var div = React.DOM.div
var GridTrack = React.createFactory(require('../GridTrack'))

module.exports = React.createClass({
  displayName: 'Grid',

  render() {
    return div({className: 'Grid'},
      this.props.tracks.map(track => {
        return GridTrack({ track, onClick: this.play.bind(null, track), key: track.id })
      })
    )
  },

  play(track) {
    return this.props.controls.play(track)
  }
})
