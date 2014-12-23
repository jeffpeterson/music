var React = require('react')
var div = React.DOM.div

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}


module.exports = React.createClass({
  displayName: 'QueueTrack',

  render: function() {
    var style = {
      backgroundImage: 'url(' + artUrl(this.props.track) + ')'
    }

    return div({
      className: 'QueueTrack',
      style: style,
      onClick: this.props.onClick
    })
  }
})
