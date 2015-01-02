var React = require('react/addons')
var div = React.DOM.div
var span = React.DOM.span

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}

module.exports = React.createClass({
  displayName: 'GridTrack',

  handleDragStart: function(e) {
    e.dataTransfer.setData('application/json', JSON.stringify(this.props.track))
  },

  render: function() {
    var style = {
      backgroundImage: 'url(' + artUrl(this.props.track) + ')'
    }

    return div(
      {
        className: 'GridTrack Ratio',
        draggable: true,
        style: style,
        onDragStart: this.handleDragStart,
        onClick: this.props.onClick
      },
      div({className: 'GridTrackContent'},
        span({className: 'GridTrackText'}, this.props.track.title)
      )
    )
  }
})
