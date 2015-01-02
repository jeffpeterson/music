var React = require('react/addons')
var div = React.DOM.div

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}


module.exports = React.createClass({
  displayName: 'QueueTrack',

  render: function() {
    var style = {
      backgroundImage: 'url(' + artUrl(this.props.track) + ')',
      marginTop: marginTop(this.props.index)
    }

    return div({
      className: 'QueueTrack Ratio',
      style: style,
      onClick: this.props.onClick
    })
  }
})

function marginTop(i) {
  if (!i) {
    return 0
  }

  i -= 1

  return i * 33 + 100 + '%'
}
