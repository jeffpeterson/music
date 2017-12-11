import {css} from 'lib'
import Base from './Base'
import QueueTrack from './QueueTrack'

export default class Queue extends Base {
  render() {
    return (
      <div
        className="Queue Ratio"
        onDrop={this.drop}
        onDragOver={this.dragOver}>
        {this.renderTracks()}
      </div>
    )
  }

  renderTracks() {
    return this.props.tracks.map((track, index) => (
      <QueueTrack
        track={track}
        index={index}
        key={track.id}
        controls={this.props.controls} />
    ))
  }

  dragOver = e => {
    e.preventDefault()
  }

  drop = e => {
    var track = JSON.parse(e.dataTransfer.getData('application/json'))
    this.props.controls.addToQueue(track)
  }
}

Queue.defaultProps = {
  tracks: [],
}

css('.Queue', {
  transform: 'translate3d(0,0,0)',
  paddingTop: 150,
  overflow: 'scroll',
  position: 'relative',
  flexShrink: 0,
})
