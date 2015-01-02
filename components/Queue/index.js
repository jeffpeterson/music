var React = require('react/addons')
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
    return div({className: 'Queue Ratio', onDrop: this.handleDrop, onDragOver: this.handleDragOver},
      this.props.tracks.map(function(track, index) {
        return QueueTrack({ track, index, key: track.id, onClick: this.play.bind(null, track) })
      }.bind(this))
    )
  },

  handleDragOver: function(e) {
    e.preventDefault();
  },

  handleDrop: function(e) {
    var track = JSON.parse(e.dataTransfer.getData('application/json'))
    this.props.controls.addToQueue(track)
  },

  play: function(track) {
    this.props.controls.play(track)
  }
})
