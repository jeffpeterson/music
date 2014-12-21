var React = require('react')
var div = React.DOM.div
var QueueTrack = React.createFactory(require('../QueueTrack'))

module.exports = React.createClass({
  displayName: 'Queue',

  getDefaultProps: function() {
    return {
      tracks: []
    }
  },

  render: function() {
    return div({className: 'Queue Ratio'},
      this.props.tracks.map(function(track) {
        return QueueTrack({ track: track, key: track.id })
      })
    )
  }
})
