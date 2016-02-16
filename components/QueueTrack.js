import {css} from 'lib'
import Base from './Base'

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}


export default class QueueTrack extends Base {
  render() {
    var style = {
      backgroundImage: 'url(' + artUrl(this.props.track) + ')',
      marginTop: marginTop(this.props.index)
    }

    return <div className='QueueTrack Ratio' style={style} onClick={this.props.onClick} />
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


function marginTop(i) {
  if (!i) {
    return 0
  }

  i -= 1

  return i * 33 + 100 + '%'
}
