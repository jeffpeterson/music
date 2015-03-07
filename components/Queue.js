import {css} from 'lib'
import {Base} from './Base'
import {QueueTrack} from './QueueTrack'

export class Queue extends Base {
  render() {
    let tracks = this.props.tracks
    .map((track, index) => <QueueTrack
      track={track}
      index={index}
      key={track.id}
      onClick={this.play.bind(null, track)} />)

    return (
      <div className={'Queue Ratio'} onDrop={this.handleDrop} onDragOver={this.handleDragOver}>
        {tracks}
      </div>
    )
  }

  handleDragOver(e) {
    e.preventDefault();
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
