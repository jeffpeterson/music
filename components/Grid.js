import {css} from 'lib'
import Base from './Base'
import GridTrack from './GridTrack'

export default class Grid extends Base {
  render() {
    let tracks = this.props.tracks
    .map(track => <GridTrack track={track} onClick={this.play.bind(this, track)} key={track.id} />)

    return <div className="Grid">{tracks}</div>
  }

  play(track) {
    return this.props.controls.play(track)
  }
}

css('.Grid', {
  transform: "translate3d(0,0,0)"
})
