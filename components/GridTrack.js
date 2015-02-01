import {css} from '../lib'
import React from 'react/addons'

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}

export default React.createClass({
  displayName: 'GridTrack',

  handleDragStart: function(e) {
    e.dataTransfer.setData('application/json', JSON.stringify(this.props.track))
  },

  render: function() {
    var style = {
      backgroundImage: 'url(' + artUrl(this.props.track) + ')'
    }

    return (
      <div className="GridTrack Ratio" draggable={true} style={style} onDragStart={this.handleDragStart} onClick={this.props.onClick}>
        <div className="GridTrackContent">
          <span className="GridTrackText GridTrackArtist">{this.props.track.user.username}</span>
          <span className="GridTrackText GridTrackTitle">{this.props.track.title}</span>
        </div>
      </div>
    )
  },
})

css('.GridTrack', {
  backgroundPosition: 'center',
  backgroundSize: 'cover',
  float: 'left',
  position: 'relative',
})

css('.GridTrack::before', {
  content: "''",
  display: 'block',
  paddingTop: '100%',
})

css('.GridTrackContent', {
  position: 'absolute',
  top: 0,
  left: 0,
  bottom: 0,
  right: 0,
  lineHeight: 24,
  color: 'white',
  display: 'flex',
  alignItems: 'flex-start',
  justifyContent: 'flex-end',
  flexDirection: 'column',
  visibility: 'hidden',
})

css('.GridTrack:hover .GridTrackContent', {
  visibility: 'visible',
})


css('.GridTrackText', {
  display: 'inline-block',
  margin: '0 5px 5px 5px',
  padding: 5,
  lineHeight: '1',
  backgroundColor: 'rgba(0,0,0, 0.8)',
  color: 'white',
})

css('.GridTrackArtist', {
  opacity: 0.8,
  fontSize: '0.9em',
})
