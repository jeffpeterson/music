import {css} from 'lib'
import {Base} from './Base'
import {QueueTrack} from './QueueTrack'

export class Queue extends Base {
  render() {
    return (
      <div
        className="Queue Ratio"
        onDrop={this.handleDrop.bind(this)}
        onDragOver={this.handleDragOver}>
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
        onClick={this.play.bind(this, track)} />
    ))
  }

  handleDragOver(e) {
    e.preventDefault()
  }

  handleDrop(e) {
    var track = JSON.parse(e.dataTransfer.getData('application/json'))
    this.props.controls.addToQueue(track)
  }

  play(track) {
    this.props.controls.play(track)
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
