import {css} from '../lib'
import React from 'react/addons'
import QueueTrack from './QueueTrack'

export default React.createClass({
  displayName: 'Queue',

  getDefaultProps: function() {
    return {
      tracks: []
    }
  },

  render: function() {
    let tracks = this.props.tracks
    .map((track, index) => <QueueTrack track={track} index={index} key={track.id} onClick={this.play.bind(null, track)} />)

    return (
      <div className={'Queue Ratio'} onDrop={this.handleDrop} onDragOver={this.handleDragOver}>
        {tracks}
      </div>
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

css('.Queue', {
  transform: 'translate3d(0,0,0)',
  paddingTop: 150,
  overflow: 'scroll',
  position: 'relative',
  flexShrink: 0,
})
