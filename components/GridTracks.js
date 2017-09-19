import {css} from 'lib'
import Base from './Base'
import GridTrack from './GridTrack'
import Grid from './Grid'

export default class GridTracks extends Base {
  render() {
    let {
      props: {loadNextPage}
    } = this

    return (
      <Grid loadNextPage={loadNextPage}>{this.renderTracks()}</Grid>
    )
  }

  renderTracks() {
    let {props: {tracks, controls}} = this

    return tracks.map(track => (
      <GridTrack track={track} controls={controls} key={track.id} />
    ))
  }
}

GridTracks.defaultProps = {
  loadNextPage() {},
}
