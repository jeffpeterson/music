import {css} from '../lib'
import React from 'react/addons'
import GridTrack from './GridTrack'

export default React.createClass({
  displayName: 'Grid',

  render() {
    let tracks = this.props.tracks
    .map(track => <GridTrack track={track} onClick={this.play.bind(null, track)} key={track.id} />)

    return <div className="Grid">{tracks}</div>
  },

  play(track) {
    return this.props.controls.play(track)
  }
})

css('.Grid', {
  transform: "translate3d(0,0,0)"
})
