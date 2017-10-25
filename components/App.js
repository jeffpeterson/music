import Chloroform from 'chloroform'
import lib from 'lib'
import client from 'client'
import {key} from 'lib/keyboard'
import {css} from 'lib/css'
import {rgb} from 'lib/color'

let ctx = lib.ctx()

import './Ratio'
import Base from './Base'
import Hue from './Hue'
import Player from './Player'
import Header from'./Header'
import GridTracks from './GridTracks'
import Queue from './Queue'
import Scrubber from './Scrubber'
import WaveForm from './WaveForm'
import Search from './Search'
import Nav from './Nav'

export default class App extends Base {
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
      bassLevel: 0,
      ...this.load()
    }

    this.addToQueue = this.addToQueue.bind(this)
    this.removeFromQueue = this.removeFromQueue.bind(this)
    this.setQuery = this.setQuery.bind(this)
    this.play = this.play.bind(this)
    this.advanceQueue = this.advanceQueue.bind(this)
    this.store = this.store.bind(this)
    this.loadNextPage = this.loadNextPage.bind(this)
    this.loadFirstPage = this.loadFirstPage.bind(this)
    this.handleScrubTimeUpdate = this.handleScrubTimeUpdate.bind(this)
    this.setBassLevel = this.setBassLevel.bind(this)
    this.onKeyDown = this.onKeyDown.bind(this)

    this.controls = {
      addToQueue: this.addToQueue,
      removeFromQueue: this.removeFromQueue,
      advanceQueue: this.advanceQueue,
      play: this.play,
    }
  }

  componentDidMount() {
    this.loadFirstPage()
    this.changeColorsToMatchTrack(this.currentTrack())
    this.loadHash()
    window.addEventListener('unload', this.store)
    window.addEventListener('keydown', this.onKeyDown)
  }

  componentWillUnmount() {
    window.removeEventListener('unload', this.store)
  }

  componentWillUpdate(props, state) {
    if (state.queue[0] !== this.state.queue[0]) {
      this.changeColorsToMatchTrack(state.queue[0])
      this.setHash(state.queue[0])
    }
  }

  render() {
    let {
      setBassLevel, onKeyDown, controls,
      state: {bassLevel, queue, colors, tracks, isPlaying, query, scrubTime}
    } = this
    let currentTrack = this.currentTrack()

    const tab = query ? 'search' : 'likes'

    // doesn't work over https:
    // <Hue {...{colors, bassLevel}} />

    return (
      <div className="App" style={this.style()} onKeyDown={onKeyDown}>
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

          <WaveForm {...{ctx, currentTrack, colors, setBassLevel}}
            isDimmed={!!query} />

          <Search {...{query}}
            onChange={this.setQuery}
            onConfirm={this.loadFirstPage} />

          <Nav>
            <Nav.Item selected={tab == 'stream'}>Stream</Nav.Item>
            <Nav.Item selected={tab == 'likes'}>Likes</Nav.Item>
            <Nav.Item selected={tab == 'search'}>Search</Nav.Item>
          </Nav>
        </Header>

        <div className="App-body">
          <Queue controls={controls} tracks={queue} />

          <GridTracks loadNextPage={this.loadNextPage} tab={tab} controls={controls} tracks={tracks} />
        </div>
      </div>
    )
  }

  style() {
    const {colors} = this.state

    return {
      backgroundColor: rgb(colors.background),
      color: rgb(colors[0]),
    }
  }

  handleScrubTimeUpdate(scrubTime) {
    this.setState({scrubTime})
  }

  setBassLevel(bassLevel) {
    this.setState({bassLevel})
  }

  addToQueue(track) {
    var queue = addTrackToQueue(this.state.queue, track)
    return this.setState({queue})
  }

  removeFromQueue(track) {
    var queue = removeTrackFromQueue(this.state.queue, track)
    return this.setState({queue})
  }

  play(track) {
    if (!track) {
      return
    }

    var queue = addTrackToQueue(this.state.queue, track)
    queue = rotateQueueToTrack(queue, track)

    const tracks = addTrack(this.state.tracks, track)

    return this.setState({
      tracks,
      queue,
      isPlaying: true
    })
  }

  playTrackId(id) {
    const track = this.state.tracks[id]

    if (track) {
      this.play(track)
    } else {
      client.track(id).then(t => this.play(t))
    }
  }

  pause() {
    this.setState({isPlaying: false})
  }

  togglePlaying() {
    this.setState({isPlaying: !this.state.isPlaying})
  }

  onKeyDown(e) {
    switch (key(e.which)) {
      case 'right':
        this.advanceQueue()
        break
      case 'space':
        this.togglePlaying()
        break

      default:
        return
    }

    e.preventDefault()
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
      lib.debug('loaded first page', tracks.length)
      this.setState({ tracks, isLoading: false })
    })
  }

  loadNextPage() {
    requestAnimationFrame(() => {
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
      .catch(e => {
        this.setState({isLoading: false})
      })
    })
  }

  currentTrack() {
    return this.state.queue[0]
  }

  loadHash() {
    const hash = window.location.hash.slice(1)
    const [_, name, id] = hash.match(/^\/(tracks)\/([^\/]+)$/) || []

    if (id) {
      this.playTrackId(id)
    }
  }

  setHash(track) {
    if (!track) return

    const hash = `#/tracks/${track.id}`
    history.replaceState({}, document.title, location.pathname + hash)
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
  overflow: 'hidden',
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
  overflow: 'hidden',
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

function addTrack(tracks, track) {
  return uniqTracks(tracks.concat(track))
}

function removeTrackFromQueue(queue, track) {
  let i = indexOfTrack(queue, track)

  if (i == null) {
    return queue
  }

  return queue.slice(0, i).concat(queue.slice(i + 1))
}

function rotateQueueToTrack(queue, track) {
  return rotateQueue(queue, indexOfTrack(queue, track))
}
