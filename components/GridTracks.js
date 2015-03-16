import {css} from 'lib'
import {Base} from './Base'
import {GridTrack} from './GridTrack'
import {Grid} from './Grid'

export class GridTracks extends Base {
  constructor(props) {
    super(props)

    this.playTrack = this.playTrack.bind(this)
  }

  render() {
    let tracks = this.props.tracks
    .map(track => <GridTrack track={track} onClick={this.playTrack} key={track.id} />)

    return <Grid>{tracks}</Grid>
  }

  playTrack(track) {
    return this.props.controls.play(track)
  }
}
