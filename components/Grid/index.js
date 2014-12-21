var React = require('react')
var div = React.DOM.div
var GridTrack = React.createFactory(require('../GridTrack'))

module.exports = React.createClass({
  displayName: 'Grid',

  render: function() {
    var play = this.props.play

    return div({className: 'Grid'},
     this.props.tracks.map(function(track) {
       return GridTrack({
         onClick: play.bind(null, track),
         track: track,
         key: track.id
       })
     })
    )
  }
})
