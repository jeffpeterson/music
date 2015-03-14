import {css} from 'lib'
import {Base} from './Base'

export class GridTrack extends Base {
  render() {
    let {track, onClick} = this.props
    let {handleDragStart} = this

    var style = {
      backgroundImage: 'url(' + artUrl(track) + ')'
    }

    return (
      <div className="GridTrack Ratio" draggable style={style} onDragStart={handleDragStart.bind(this)} onClick={onClick}>
        <div className="GridTrack-content">
          <span className="GridTrack-text GridTrack-artist">{track.user.username}</span>
          <span className="GridTrack-text GridTrack-title">{track.title}</span>
        </div>
      </div>
    )
  }

  handleDragStart(e) {
    let {track} = this.props
    e.dataTransfer.setData('application/json', JSON.stringify(track))
  }
}

css('.GridTrack', {
  backgroundPosition: 'center',
  backgroundSize: 'cover',
  float: 'left',
  position: 'relative',
})

css('.GridTrack::before', {
  content: "''",
  display: 'block',
  paddingTop: '100%',
})

css('.GridTrack-content', {
  position: 'absolute',
  top: 0,
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
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}
