import {css} from 'lib'
import Base from './Base'

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}


export default class QueueTrack extends Base {
  constructor(props) {
    super(props)

    this.onClick = this.onClick.bind(this)
    this.onRemove = this.onRemove.bind(this)
  }

  render() {
    let {
      onClick,
      onRemove,
      props: {track, index, controls}
    } = this

    var style = {
      backgroundImage: 'url(' + artUrl(track) + ')',
      marginTop: marginTop(index)
    }

    return (
      <div className='QueueTrack Ratio' style={style} onClick={onClick}>
        <div className='QueueTrack-remove' onClick={onRemove} />

        <div className="QueueTrack-content">
          <span className="QueueTrack-text QueueTrack-artist">{track.user.username}</span>
          <span className="QueueTrack-text QueueTrack-title">{track.title}</span>
        </div>
      </div>
    )
  }

  onRemove(e) {
    e.stopPropagation()
    e.preventDefault()

    this.props.controls.removeFromQueue(this.props.track)
  }

  onClick() {
    this.props.controls.play(this.props.track)
  }
}

css('.QueueTrack', {
  backgroundSize: 'cover',
  backgroundPosition: 'center center',
  position: 'absolute',
  transition: '0.5s',
})

css('.QueueTrack::before', {
  transition: '0.5s',
  paddingTop: '33.333%',
  content: "''",
  display: 'block',
})

css('.QueueTrack:first-child::before', {
  paddingTop: '100%',
})

css('.QueueTrack:last-child', {
  marginBottom: '33%',
})

css('.QueueTrack-remove', {
  position: 'absolute',
  right: 0,
  color: 'white',
  top: 0,
  display: 'none',
  padding: '4px 2px 1px',
  margin: 3,
  backgroundColor: 'rgba(0,0,0, 0.4)',
})

css('.QueueTrack-remove::before', {
  content: "'×'",
  fontSize: 30,
  lineHeight: 1,
})

css('.QueueTrack:hover .QueueTrack-remove', {
  display: 'block'
})

css('.QueueTrack-content', {
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

css('.QueueTrack:hover .QueueTrack-content', {
  visibility: 'visible',
})


css('.QueueTrack-text', {
  display: 'inline-block',
  margin: '0 5px 5px 5px',
  padding: 5,
  lineHeight: '1',
  backgroundColor: 'rgba(0,0,0, 0.8)',
  color: 'white',
})

css('.QueueTrack-artist', {
  opacity: 0.8,
  fontSize: '0.9em',
})

function marginTop(i) {
  if (!i) {
    return 0
  }

  i -= 1

  return i * 33 + 100 + '%'
}
