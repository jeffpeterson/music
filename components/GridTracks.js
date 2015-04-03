import {css} from 'lib'
import {Base} from './Base'
import {GridTrack} from './GridTrack'
import {LazyGrid} from './LazyGrid'

export class GridTracks extends Base {
  constructor(props) {
    super(props)

    this.playTrack = this.playTrack.bind(this)
    this.renderTrackAtIndex = this.renderTrackAtIndex.bind(this)
  }

  render() {
    return <LazyGrid getter={this.renderTrackAtIndex} />
  }

  renderTrackAtIndex(i) {
    let {tracks, loadNextPage} = this.props
    let track = tracks[i]
    if (i >= tracks.length) {
      loadNextPage()
    }

    if (!track) {
      return
    }

    return <GridTrack track={track} onClick={this.playTrack} key={track.id} />
  }

  playTrack(track) {
    return this.props.controls.play(track)
  }
}

GridTracks.defaultProps = {
  loadNextPage() {},
}
