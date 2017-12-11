import {css} from 'lib'
import Base from './Base'

export default class GridTrack extends Base {
  render() {
    let {track, dispatch} = this.props

    var style = {
      backgroundImage: 'url(' + artUrl(track) + ')'
    }

    return (
      <div className="GridTrack" draggable style={style} onDragStart={this.dragStart} onClick={this.click}>
        <div className="GridTrack-content">
          <span className="GridTrack-text GridTrack-artist">{track.user.username}</span>
          <span className="GridTrack-text GridTrack-title">{track.title}</span>
        </div>
      </div>
    )
  }

  click = e => {
    const {dispatch, track} = this.props
    dispatch('TRACK_CLICKED', {id: track.id})
  }

  dragStart = e => {
    let {track} = this.props
    e.dataTransfer.setData('application/json', JSON.stringify(track))
  }
}

css('.GridTrack', {
  backgroundPosition: 'center',
  backgroundSize: 'cover',
  width: '100%',
  height: '100%',
  position: 'absolute',
  top: 0,
  left: 0
})

css('.GridTrack:active', {
  transform: 'scale(0.9)',
})

css('.GridTrack-content', {
  position: 'absolute',
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

css('.GridTrack:hover .GridTrack-content', {
  visibility: 'visible',
})


css('.GridTrack-text', {
  display: 'inline-block',
  margin: '0 5px 5px 5px',
  padding: 5,
  lineHeight: '1',
  backgroundColor: 'rgba(0,0,0, 0.8)',
  color: 'white',
})

css('.GridTrack-artist', {
  opacity: 0.8,
  fontSize: '0.9em',
})

function artUrl(track) {
  var url = track.artworkUrl || track.user.avatarUrl || ''
  return url.replace('-large', '-t500x500')
}
