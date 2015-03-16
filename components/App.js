import Chloroform from 'chloroform'
import lib from 'lib'
import client from 'client'

let {css} = lib

let ctx = lib.ctx()

import './Ratio'
import {Base} from './Base'
import {Player} from './Player'
import {Header} from'./Header'
import {GridTracks} from './GridTracks'
import {Queue} from './Queue'
import {Scroller} from './Scroller'
import {Scrubber} from './Scrubber'
import {WaveForm} from './WaveForm'
import {Search} from './Search'
import {Menu} from './Menu'

export class App extends Base {
  constructor(props) {
    super(props)

    this.state = {
      query: '',
      tracks: [],
      favorites: [],
      isLoading: true,
      isPlaying: true,
      scrubTime: 0,
      colors: {},
      queue: [],
      ...this.load()
    }

    this.addToQueue = this.addToQueue.bind(this)
    this.setQuery = this.setQuery.bind(this)
    this.play = this.play.bind(this)
    this.advanceQueue = this.advanceQueue.bind(this)
    this.store = this.store.bind(this)
    this.loadNextPage = this.loadNextPage.bind(this)
    this.loadFirstPage = this.loadFirstPage.bind(this)
    this.handleScrubTimeUpdate = this.handleScrubTimeUpdate.bind(this)

    this.controls = {
      addToQueue: this.addToQueue,
      advanceQueue: this.advanceQueue,
      play: this.play,
    }
  }

  componentDidMount() {
    this.loadFirstPage()
    this.changeColorsToMatchTrack(this.state.queue[0])
    window.addEventListener('unload', this.store)
  }

  componentDidUnmount() {
    window.removeEventListener('unload', this.store)
  }

  componentWillUpdate(props, state) {
    if (state.queue[0] !== this.state.queue[0]) {
      this.changeColorsToMatchTrack(state.queue[0])
    }
  }

  render() {
    let {queue, colors, tracks, isPlaying, query, scrubTime} = this.state
    let currentTrack = this.currentTrack()
    let controls = this.controls

    return (
      <div className="App" style={this.style()}>
        <Player {...{ctx, isPlaying}}
          ref="player"
          track={currentTrack}
          onEnded={this.advanceQueue}
          onError={this.advanceQueue}
          scrubTime={scrubTime}
          updateScrubTime={this.handleScrubTimeUpdate} />

        <Header {...{colors}} >
          <Scrubber {...{colors, scrubTime}}
            duration={currentTrack && currentTrack.duration}
            onScrub={this.handleScrubTimeUpdate} />

          <WaveForm {...{ctx, currentTrack, colors}}
            isDimmed={!!query} />

          <Search {...{query}}
            onChange={this.setQuery}
            onConfirm={this.loadFirstPage} />

        </Header>

        <div className="App-body">
          <Queue controls={controls} tracks={queue} />
          <Scroller loadNextPage={this.loadNextPage}>
            <GridTracks controls={controls} tracks={tracks} />
          </Scroller>
        </div>
      </div>
    )
  }

  style() {
    return {
      backgroundColor: 'rgb(' + this.state.colors.background + ')'
    }
  }

  handleScrubTimeUpdate(scrubTime) {
    this.setState({scrubTime})
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

  setQuery(query) {
    return this.setState({query})
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

  store() {
    var json = JSON.stringify(lib.only(this.state,
      'queue',
      'query',
      'isPlaying',
      'colors',
      'scrubTime'
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
