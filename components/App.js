import Chloroform from 'chloroform'
import lib from 'lib'
import client from 'client'

let {css} = lib

let ctx = lib.ctx()

import './Ratio'
import {Base} from './Base'
import {Player} from './Player'
import {Header} from'./Header'
import {Grid} from './Grid'
import {Queue} from './Queue'
import {Scroller} from './Scroller'

export class App extends Base {
  constructor(props) {
    super(props)

    this.state = Object.assign({
      query: '',
      tracks: [],
      favorites: [],
      isLoading: true,
      isPlaying: true,
      scrubTime: 0,
      colors: [],
      queue: []
    }, this.load())
  }

  componentDidMount() {
    this.loadFirstPage()
    this.changeColorsToMatchTrack(this.state.queue[0])
  }

  componentDidUpdate(props, state) {
    this.store(this.state)
  }

  componentWillUpdate(props, state) {
    if (state.queue[0] !== this.state.queue[0]) {
      this.changeColorsToMatchTrack(state.queue[0])
    }
  }

  render() {
    var controls = this.controls()

    var style = {
      backgroundColor: 'rgb(' + this.state.colors.background + ')'
    }

    return (
      <div className="App" style={style}>
        <Player ctx={ctx} track={this.state.queue[0]} isPlaying={this.state.isPlaying} onEnded={this.advanceQueue} onError={this.advanceQueue} updateScrubTime={this.updateScrubTime} />
        <Header ctx={ctx} colors={this.state.colors} currentTrack={this.currentTrack()} query={this.state.query} setQuery={this.setQuery} />
        <div className="App-body">
          <Queue controls={controls} tracks={this.state.queue} />
          <Scroller onUpdate={this.onScrollerUpdate} loadNextPage={this.loadNextPage}>
            <Grid controls={controls} tracks={this.state.tracks} />
          </Scroller>
        </div>
      </div>
    )
  }

  updateScrubTime(time) {
    // lib.debug('time update', time)
  }

  addToQueue(track) {
    var queue = addTrackToQueue(this.state.queue, track)
    return this.setState({queue})
  }

  play(track) {
    if (!track) {
      return
    }

    var queue = addTrackToQueue(this.state.queue, track)
    queue = rotateQueueToTrack(queue, track)
    return this.setState({queue})
  }


  advanceQueue() {
    var queue = rotateQueue(this.state.queue, 1)
    return this.setState({queue})
  }

  controls() {
    return {
      addToQueue: this.addToQueue.bind(this),
      play: this.play.bind(this),
      advanceQueue: this.advanceQueue.bind(this)
    }
  }

  setQuery(query) {
    return this.setState({query}, this.loadFirstPage)
  }

  request(options) {
    if (this.state.query) {
      return client.tracks(options)
    } else {
      return client.favorites(options)
    }
  }

  loadFirstPage() {
    this.request({
      query: this.state.query
    })
    .then(tracks => {
      this.setState({
        tracks: tracks,
        isLoading: false
      })
    })
  }

  loadNextPage() {
    if (this.state.isLoading) {
      return
    }

    lib.debug('loading next page with offset:', this.state.tracks.length)

    this.setState({ isLoading: true })

    return this.request({
      offset: this.state.tracks.length,
      query: this.state.query
    })
    .then(tracks => {
      lib.debug('received', tracks.length, 'tracks')

      this.setState({
        isLoading: false,
        tracks: uniqTracks(this.state.tracks.concat(tracks))
      })
    })
  }

  currentTrack() {
    return this.state.queue[0]
  }

  changeColorsToMatchTrack(track) {
    if (!track) {
      return
    }

    Chloroform.analyze(artUrl(track), colors => {
      this.setState({ colors: colors })
    })
  }

  store(state) {
    var json = JSON.stringify(lib.only(state,
      'queue',
      'query',
      'isPlaying',
      'colors'
    ))

    window.localStorage.setItem('App.state', json)
  }

  load() {
    var str = window.localStorage.getItem('App.state')

    if (str) {
      return JSON.parse(str)
    }

    return {}
  }
}

css('.App', {
  height: '100%',
  position: 'relative',
  backgroundColor: 'black',
  color: '#888',
  fontFamily: 'Helvetica Neue',
  fontWeight: 200,
})

css('.App-body', {
  height: '100%',
  display: 'flex',
  alignItems: 'stretch',
  position: 'relative',
  overflow: 'hidden',
})

css('html, body, #mount', {
  margin: 0,
  padding: 0,
  height: '100%',
  position: 'relative',
})

css('::-webkit-scrollbar', {
  display: 'none',
})

function uniqTracks(tracks) {
  var index = {}

  return tracks.reverse().filter(track => {
    if (!index[track.id]) {
      return index[track.id] = true
    }
  }).reverse()
}

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}


function indexOfTrack(queue, track) {
  var index = queue.findIndex(t => t.id === track.id)

  if (index >= 0) {
    return index
  }
}

function rotateQueue(queue, n) {
  if (!n) {
    return queue
  }

  lib.debug('rotating queue', n)

  return lib.rotate(queue, n)
}

function addTrackToQueue(queue, track) {
  return uniqTracks(queue.concat(track).reverse()).reverse()
}

function rotateQueueToTrack(queue, track) {
  return rotateQueue(queue, indexOfTrack(queue, track))
}
